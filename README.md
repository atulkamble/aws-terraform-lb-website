# Basic Website with Load Balancer on AWS

This Terraform project deploys a basic website with a public Application Load Balancer on AWS. The infrastructure is highly available, scalable, and follows AWS best practices.

## 🏗️ Architecture

The project creates:

- **VPC** with public and private subnets across 2 Availability Zones
- **Application Load Balancer** (ALB) in public subnets for high availability
- **Auto Scaling Group** with EC2 instances in private subnets
- **NAT Gateways** for outbound internet access from private instances
- **Security Groups** with proper ingress/egress rules
- **Apache web servers** serving a custom HTML page

## 📁 Project Structure

```
.
├── main.tf           # Main Terraform configuration (VPC, ALB, Security Groups)
├── compute.tf        # EC2 instances, Auto Scaling Group, NAT Gateways
├── variables.tf      # Variable definitions
├── outputs.tf        # Output values
├── terraform.tfvars  # Variable values (customize this)
├── user-data.sh      # Bootstrap script for EC2 instances
└── README.md         # This file
```

## 🚀 Quick Start

### Prerequisites

1. **AWS CLI configured** with appropriate credentials
2. **Terraform installed** (version >= 1.0)
3. **AWS account** with necessary permissions

### Deployment Steps

1. **Clone and navigate to the project:**
   ```bash
   cd /path/to/project
   ```

2. **Customize variables (optional):**
   Edit `terraform.tfvars` to customize:
   - AWS region
   - Project name
   - Instance types and scaling settings
   - Network CIDR blocks

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Review the deployment plan:**
   ```bash
   terraform plan
   ```

5. **Deploy the infrastructure:**
   ```bash
   terraform apply
   ```
   Type `yes` when prompted.

6. **Access your website:**
   After deployment (5-10 minutes), the website URL will be displayed in the output.

## 🔧 Customization

### Variables

Key variables you can customize in `terraform.tfvars`:

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region for deployment | `us-west-2` |
| `project_name` | Name prefix for resources | `my-website` |
| `instance_type` | EC2 instance type | `t3.micro` |
| `desired_capacity` | Number of EC2 instances | `2` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |

### Website Content

To customize the website content:
1. Edit `user-data.sh` and modify the HTML content
2. Run `terraform apply` to update instances

### SSL/HTTPS (Optional Enhancement)

To add HTTPS support:
1. Request an SSL certificate from AWS Certificate Manager
2. Add HTTPS listener to the load balancer
3. Update security groups to allow port 443

## 📊 Monitoring and Management

### Accessing EC2 Instances

If you want SSH access to instances:
1. Create an EC2 Key Pair in AWS Console
2. Set `key_pair_name` in `terraform.tfvars`
3. Use a bastion host or AWS Systems Manager Session Manager

### Scaling

The Auto Scaling Group automatically:
- Maintains desired number of healthy instances
- Scales out under high load (if configured)
- Replaces unhealthy instances

### Load Balancer Health Checks

The ALB performs health checks on:
- **Path:** `/`
- **Port:** `80`
- **Expected response:** `200 OK`

## 💰 Cost Considerations

**Estimated monthly cost (us-west-2, as of 2024):**
- 2 × t3.micro instances: ~$15
- Application Load Balancer: ~$18
- 2 × NAT Gateways: ~$64
- Data transfer: Variable
- **Total: ~$97/month**

**Cost optimization tips:**
- Use t3.nano for lower costs (if sufficient)
- Consider single NAT Gateway for dev environments
- Use Reserved Instances for production

## 🛡️ Security Features

- **Private subnets** for EC2 instances (not directly internet-accessible)
- **Security groups** with minimal required access
- **Load balancer** as single entry point
- **Regular security updates** via user data script

**Security considerations:**
- SSH access is open to 0.0.0.0/0 by default - restrict this in production
- Consider using AWS Systems Manager instead of SSH
- Enable VPC Flow Logs for network monitoring
- Use AWS WAF for additional web application protection

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted. This will remove all AWS resources created by this project.

## 📚 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Application Load Balancer Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [AWS Auto Scaling Documentation](https://docs.aws.amazon.com/autoscaling/ec2/userguide/)

## 🐛 Troubleshooting

### Website not accessible
1. Check if deployment is complete: `terraform output`
2. Verify security group rules allow HTTP traffic
3. Check Auto Scaling Group has healthy instances
4. Review load balancer target group health

### SSL certificate issues
1. Ensure certificate is in the same region
2. Verify domain validation is complete
3. Check certificate ARN in configuration

### High costs
1. Review NAT Gateway usage (consider single NAT for dev)
2. Check instance types and Auto Scaling settings
3. Monitor data transfer costs

---

**Happy coding! 🚀**