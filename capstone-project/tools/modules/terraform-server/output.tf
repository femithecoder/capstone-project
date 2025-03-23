output "public_ip" {
  value = aws_instance.terraform-server.public_ip
}
output "private_ip" {
  value = aws_instance.terraform-server.private_ip
}
