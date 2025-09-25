terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Optional: Configure backend for state storage
  # Uncomment and customize for production use
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "basic-website/terraform.tfstate"
  #   region         = "us-west-2"
  #   dynamodb_table = "terraform-state-locking"
  #   encrypt        = true
  # }
}