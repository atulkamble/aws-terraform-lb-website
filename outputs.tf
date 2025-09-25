output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "load_balancer_url" {
  description = "URL of the Application Load Balancer"
  value       = "http://${aws_lb.main.dns_name}"
}

output "load_balancer_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "load_balancer_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "security_group_alb_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "security_group_web_id" {
  description = "ID of the web servers security group"
  value       = aws_security_group.web.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.web.id
}

output "website_instructions" {
  description = "Instructions for accessing the website"
  value = <<-EOT
    Your website is now deployed! 
    
    🌐 Website URL: http://${aws_lb.main.dns_name}
    
    📝 What was deployed:
    - VPC with public and private subnets across 2 AZs
    - Application Load Balancer (publicly accessible)
    - Auto Scaling Group with ${var.desired_capacity} EC2 instances
    - Security groups for web tier and load balancer
    - NAT Gateways for outbound internet access from private subnets
    
    🔧 To customize:
    - Edit variables in terraform.tfvars
    - Modify user-data.sh for different web content
    - Adjust Auto Scaling Group settings in variables.tf
    
    🚀 The website should be accessible within 5-10 minutes of deployment.
  EOT
}