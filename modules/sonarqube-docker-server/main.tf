resource "aws_instance" "sonarqube-docker-server" {
  ami = var.ami
  instance_type = var.instance_type 
  key_name = var.key_name
  user_data = file("${path.module}/install.sh")
  subnet_id = module.vpc.public_subnets[1]
  associate_public_ip_address = true
  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.volume_type
  }
  vpc_security_group_ids = [aws_security_group.slavenode1-sg]
}

resource "aws_security_group" "slavenode1-sg" {
  name = "sonarqube-docker-sg"
  description = "allow TLS inbound traffic and all outbound traffic"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  
  tags = {
    Name = "sonarqube-docker-sg"
  }
}
