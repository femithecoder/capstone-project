resource "aws_instance" "terraform-server" {
  ami = var.ami
  instance_type = var.instance_type 
  key_name = var.key_name
  user_data = file("${path.module}/terraform.sh")
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]

  tags = {
    Name = "terraform-server"
  }
}

resource "aws_security_group" "terraform_sg" {
  name = "terraform_sg"
  description = "allow TLS inbound traffic and all outbound traffic"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port     = 22
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
    Name = "terraform-sg"
  }
}
