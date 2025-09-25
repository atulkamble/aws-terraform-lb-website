# AWS Configuration
aws_region = "us-west-2"

# Project Configuration
project_name = "my-website"
environment  = "production"

# Network Configuration
vpc_cidr               = "10.0.0.0/16"
public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs   = ["10.0.10.0/24", "10.0.20.0/24"]

# Security Configuration
# WARNING: 0.0.0.0/0 allows SSH from anywhere - restrict this in production
ssh_cidr_block = "0.0.0.0/0"

# Compute Configuration
instance_type      = "t3.micro"
min_size          = 2
max_size          = 4
desired_capacity  = 2

# EC2 Key Pair (optional - uncomment and set if you want SSH access)
# key_pair_name = "my-key-pair"