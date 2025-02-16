resource "aws_instance" "jenkins-server" {
  ami = var.ami
  instance_type = var.instance_type 
  key_name = var.key_name
  user_data = file("${path.module}/jenkins.sh")
  subnet_id = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
}

resource "aws_security_group" "jenkins_sg" {
  name = "jenkins-sg"
  description = "allow TLS inbound traffic and all outbound traffic"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port     = 8080
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
    Name = "jenkins-master-sg"
  }
}
