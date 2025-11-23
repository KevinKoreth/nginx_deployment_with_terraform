# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data source to fetch the latest Ubuntu 20.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group for EC2 instance
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-security-group"
  description = "Security group for Nginx web server"

  # Inbound HTTP traffic
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound SSH traffic
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic - allow all
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "nginx-security-group"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# EC2 Instance with Nginx
resource "aws_instance" "nginx_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  # User data script to install and configure Nginx
  user_data = <<-EOF
              #!/bin/bash
              # Update package list
              apt-get update -y
              
              # Install Nginx
              apt-get install nginx -y
              
              # Create custom HTML page
              cat > /var/www/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html lang="en">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Terraform Nginx Server</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          display: flex;
                          justify-content: center;
                          align-items: center;
                          height: 100vh;
                          margin: 0;
                          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                          color: white;
                      }
                      .container {
                          text-align: center;
                          padding: 2rem;
                          background: rgba(255, 255, 255, 0.1);
                          border-radius: 10px;
                          box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
                      }
                      h1 {
                          font-size: 2.5rem;
                          margin-bottom: 1rem;
                      }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>Welcome to the Terraform-managed Nginx Server on Ubuntu</h1>
                      <p>This server was automatically provisioned using Infrastructure as Code</p>
                  </div>
              </body>
              </html>
              HTML
              
              # Start and enable Nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name        = "terraform-nginx-ubuntu"
    Environment = "Development"
    ManagedBy   = "Terraform"
    Project     = "EC2-Nginx-Deployment"
  }
}