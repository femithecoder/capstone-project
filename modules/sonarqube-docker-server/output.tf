output "public_ip" {
  value = aws_instance.sonarqube-docker-server.public_ip
}
output "private_ip" {
  value = aws_instance.sonarqube-docker-server.private_ip
}