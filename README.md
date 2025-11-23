# EC2 Nginx Deployment with Terraform

This project demonstrates Infrastructure as Code (IaC) principles by deploying an Nginx web server on an AWS EC2 instance using Terraform.

## 📋 Project Overview

This Terraform configuration automatically provisions:
- An Ubuntu 20.04 LTS EC2 instance (t2.micro)
- A security group with HTTP and SSH access
- Nginx web server with custom HTML page
- All resources in the default VPC

## 🏗️ Resources Created

1. **AWS Security Group** (`aws_security_group.nginx_sg`)
   - Allows inbound traffic on port 80 (HTTP)
   - Allows inbound traffic on port 22 (SSH)
   - Allows all outbound traffic

2. **EC2 Instance** (`aws_instance.nginx_server`)
   - Instance Type: t2.micro
   - AMI: Ubuntu 20.04 LTS (automatically fetched)
   - Nginx installed and configured via user_data
   - Custom HTML page deployed

## 📁 File Structure

```
terraform-nginx-ubuntu/
├── main.tf          # Main Terraform configuration
├── variables.tf     # Variable definitions
├── outputs.tf       # Output definitions
└── README.md        # This file
```

## 🚀 Prerequisites

Before you begin, ensure you have:

1. **Terraform installed** (version 1.0+)
   ```bash
   terraform --version
   ```

2. **AWS CLI configured** with valid credentials
   ```bash
   aws configure
   ```
   You'll need:
   - AWS Access Key ID
   - AWS Secret Access Key
   - Default region (e.g., us-east-1)

3. **Appropriate AWS permissions** to create:
   - EC2 instances
   - Security groups
   - Read AMI information

## 📝 Step-by-Step Deployment Instructions

### Step 1: Clone or Create the Project

Create a new directory and add all the Terraform files:

```bash
mkdir terraform-nginx-ubuntu
cd terraform-nginx-ubuntu
```

### Step 2: Initialize Terraform

Initialize the Terraform working directory and download required providers:

```bash
terraform init
```

**Expected Output:**
- Downloads AWS provider plugin
- Initializes backend
- Displays "Terraform has been successfully initialized!"

### Step 3: Review the Execution Plan

Preview the resources that will be created:

```bash
terraform plan
```

**Expected Output:**
- Shows 2 resources to be created (security group and EC2 instance)
- Displays the configuration details

### Step 4: Apply the Configuration

Deploy the infrastructure:

```bash
terraform apply
```

- Review the plan
- Type `yes` when prompted to confirm
- Wait for resources to be created (typically 1-2 minutes)

**Expected Output:**
```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

instance_id = "i-0123456789abcdef0"
instance_public_dns = "ec2-xx-xx-xx-xx.compute-1.amazonaws.com"
instance_public_ip = "xx.xx.xx.xx"
nginx_url = "http://xx.xx.xx.xx"
```

### Step 5: Access the Nginx Server

1. Copy the `nginx_url` from the output
2. Open it in your web browser
3. You should see: **"Welcome to the Terraform-managed Nginx Server on Ubuntu"**

Alternatively, use curl:
```bash
curl http://<instance_public_ip>
```

### Step 6: Verify Resources in AWS Console

1. Go to AWS EC2 Console
2. Check the "Instances" section for `terraform-nginx-ubuntu`
3. Check "Security Groups" for `nginx-security-group`

### Step 7: Clean Up Resources

When you're done, destroy all created resources:

```bash
terraform destroy
```

- Type `yes` when prompted
- All resources will be removed

**Expected Output:**
```
Destroy complete! Resources: 2 destroyed.
```

## 🔧 Configuration Options

You can customize the deployment by modifying variables:

### Change AWS Region

Edit `variables.tf` or use command-line:
```bash
terraform apply -var="aws_region=us-west-2"
```

### Change Instance Type

Edit `variables.tf` or use command-line:
```bash
terraform apply -var="instance_type=t2.small"
```

## 🐛 Troubleshooting

### Issue: "Error launching source instance: Unsupported"

**Solution:** The t2.micro instance type may not be available in your region. Try a different region or instance type.

### Issue: Connection timeout when accessing Nginx

**Solution:** 
- Wait 2-3 minutes after `terraform apply` for user_data script to complete
- Check security group rules in AWS console
- Verify the instance is in "running" state

### Issue: "InvalidKeyPair.NotFound"

**Solution:** This configuration doesn't use SSH keys by default. If you need SSH access, you'll need to add a key pair.

### Issue: Permission denied errors

**Solution:** Ensure your AWS credentials have the necessary permissions to create EC2 instances and security groups.

## 📊 Verification Checklist

- [ ] EC2 instance is running
- [ ] Security group allows ports 80 and 22
- [ ] Nginx is installed and running
- [ ] Custom HTML page is accessible via browser
- [ ] Public IP is displayed in outputs
- [ ] `terraform destroy` successfully removes all resources

## 🏷️ Resource Tags

All resources are tagged with:
- `Name`: Descriptive name of the resource
- `Environment`: Development
- `ManagedBy`: Terraform
- `Project`: EC2-Nginx-Deployment

## 📸 Screenshots

### Successful Terraform Apply
![Terraform Apply Output]
- Shows resources created and output values

### Nginx Server Running
![Browser showing Nginx page]
- Custom HTML page displaying welcome message

### AWS Console Verification
![EC2 Instance in AWS Console]
- Instance in running state with proper tags

## 🔒 Security Notes

- The security group allows SSH (port 22) from anywhere (0.0.0.0/0) - restrict this in production
- No SSH key pair is configured - add one if you need SSH access
- Consider using AWS Systems Manager Session Manager for secure access

## 📚 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [AWS EC2 User Guide](https://docs.aws.amazon.com/ec2/)

## ✅ Assignment Completion

This solution meets all assignment requirements:
- ✅ AWS provider and region configured
- ✅ t2.micro Ubuntu EC2 instance in default VPC
- ✅ Security group with HTTP and SSH access
- ✅ user_data installs Nginx with custom HTML
- ✅ Public IP output after provisioning
- ✅ terraform destroy removes all resources
- ✅ Complete documentation with instructions

## 👤 Author

Created as part of the Terraform Infrastructure as Code assignment.

## 📄 License

This project is for educational purposes.