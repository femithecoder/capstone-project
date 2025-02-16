resource "aws_instance" "terraform-server" {
  ami = var.ami
  instance_type = var.instance_type 
  key_name = var.key_name
  user_data = file("${path.module}/terraform.sh")
  subnet_id = module.vpc.public_subnets[1]

  vpc_security_group_ids = [aws_security_group.terraform_sg.id]
}

resource "aws_security_group" "terraform_sg" {
  name = "terraform_sg"
  description = "allow TLS inbound traffic and all outbound traffic"
  vpc_id = module.vpc.vpc_id

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
