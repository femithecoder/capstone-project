#!/bin/bash

# Update package list and install dependencies
sudo apt update -y
sudo apt install -y wget unzip python3-pip -y

# Installing AWS CLI (if not already installed)
if ! command -v aws &> /dev/null; then
    echo "Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws/
fi

# SonarQube Variables
SONARQUBE_VERSION=10.5.1.90531
SONAR_DB="ddsonarqube"
SONAR_USER="ddsonar"
APP_DB="myappdb"
APP_USER="myappuser"
RDS_HOST="localhost"  # Change this if using RDS

# Generate random passwords for SonarQube & Application databases
SONAR_DB_PASSWORD=$(openssl rand -base64 12)
APP_DB_PASSWORD=$(openssl rand -base64 12)

# Store passwords in AWS Secrets Manager
aws secretsmanager create-secret --name sonar-db-password --secret-string "$SONAR_DB_PASSWORD" --region us-east-1 || \
aws secretsmanager update-secret --secret-id sonar-db-password --secret-string "$SONAR_DB_PASSWORD" --region us-east-1

aws secretsmanager create-secret --name app-db-password --secret-string "$APP_DB_PASSWORD" --region us-east-1 || \
aws secretsmanager update-secret --secret-id app-db-password --secret-string "$APP_DB_PASSWORD" --region us-east-1

# Store database credentials in system environment variables
echo "Setting up environment variables..."
echo "SONAR_DB_PASSWORD=$SONAR_DB_PASSWORD" | sudo tee -a /etc/environment
echo "APP_DB_PASSWORD=$APP_DB_PASSWORD" | sudo tee -a /etc/environment

# ✅ Step 1: Install PostgreSQL First
echo "Installing PostgreSQL..."
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo apt update -y
sudo apt install postgresql postgresql-contrib -y

# Enable and start PostgreSQL service
sudo systemctl enable postgresql
sudo systemctl start postgresql

# ✅ Step 2: Create Databases & Users for SonarQube and Application
echo "Creating Databases & Users..."
sudo -i -u postgres psql <<EOF
-- Create SonarQube user and database
CREATE USER $SONAR_USER WITH ENCRYPTED PASSWORD '$SONAR_DB_PASSWORD';
CREATE DATABASE $SONAR_DB OWNER $SONAR_USER;
GRANT ALL PRIVILEGES ON DATABASE $SONAR_DB TO $SONAR_USER;

-- Create Application user and database
CREATE USER $APP_USER WITH ENCRYPTED PASSWORD '$APP_DB_PASSWORD';
CREATE DATABASE $APP_DB OWNER $APP_USER;
GRANT ALL PRIVILEGES ON DATABASE $APP_DB TO $APP_USER;
EOF

# ✅ Step 3: Install SonarQube AFTER PostgreSQL
echo "Downloading and installing SonarQube..."
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip
if [ $? -ne 0 ]; then
    echo "Failed to download SonarQube. Exiting."
    exit 1
fi

unzip -o sonarqube-${SONARQUBE_VERSION}.zip -d /opt
sudo mv /opt/sonarqube-${SONARQUBE_VERSION} /opt/sonarqube

# Ensure binaries have executable permissions
sudo chmod +x /opt/sonarqube/bin/linux-x86-64/sonar.sh

# Create SonarQube group and user if not exists
if ! getent group ddsonar > /dev/null; then
    sudo groupadd ddsonar
fi

if ! id -u ddsonar > /dev/null 2>&1; then
    sudo useradd -g ddsonar -d /opt/sonarqube -s /bin/bash ddsonar
fi

sudo chown -R ddsonar:ddsonar /opt/sonarqube

# ✅ Step 4: Configure SonarQube to Use PostgreSQL
echo "Configuring SonarQube database connection..."
sudo bash -c "cat <<EOF > /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=$SONAR_USER
sonar.jdbc.password=$SONAR_DB_PASSWORD
sonar.jdbc.url=jdbc:postgresql://$RDS_HOST:5432/$SONAR_DB
EOF"

# ✅ Step 5: Set Up SonarQube as a Service
echo "Creating SonarQube systemd service..."
echo -e "[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=ddsonar
Group=ddsonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/sonar.service

# Reload systemd and start SonarQube service
sudo systemctl daemon-reload
sudo systemctl enable sonar.service
sudo systemctl start sonar.service

# Update existing package list
sudo apt update -y

# Install prerequisite packages for Docker
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg \
    lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list to include Docker packages
sudo apt update -y

# Install Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker service
sudo systemctl start docker

# Verify Docker installation
sudo docker --version

# Optional: Add the current user to the 'docker' group to avoid using 'sudo' for Docker commands
sudo usermod -aG docker $USER

echo "Docker installation completed successfully."
echo "Please log out and log back in to apply group changes."
