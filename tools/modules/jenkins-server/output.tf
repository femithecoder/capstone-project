output "public_ip" {
  value = aws_instance.jenkins-server.public_ip
}
output "private_ip" {
  value = aws_instance.jenkins-server.private_ip
}
