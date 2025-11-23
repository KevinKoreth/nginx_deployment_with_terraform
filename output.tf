# Output the public IP address of the EC2 instance
output "instance_public_ip" {
  description = "Public IP address of the Nginx EC2 instance"
  value       = aws_instance.nginx_server.public_ip
}

# Output the public DNS of the EC2 instance
output "instance_public_dns" {
  description = "Public DNS of the Nginx EC2 instance"
  value       = aws_instance.nginx_server.public_dns
}

# Output the instance ID
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.nginx_server.id
}

# Output the URL to access the Nginx server
output "nginx_url" {
  description = "URL to access the Nginx web server"
  value       = "http://${aws_instance.nginx_server.public_ip}"
}