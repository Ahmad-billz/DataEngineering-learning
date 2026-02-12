#             ######## ======== tf backend ======== ########
terraform {
  # Remote state backend
  backend "s3" {
    bucket         = "iac-remote-state-bucket-001"   # replace with your S3 bucket name
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"           # DynamoDB table for locking
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# AWS provider
provider "aws" {
  region = "us-east-1"
}

# Example resource: Demo S3 bucket
resource "aws_s3_bucket" "demo" {
  bucket = "iac-remote-demo-bucket-${random_id.suffix.hex}" # globally unique
  tags = {
    Name = "iac-remote-demo"
    Env  = "dev"
  }
}

# Add random suffix so bucket name is unique
resource "random_id" "suffix" {
  byte_length = 4
}

# Output bucket name
output "bucket_name" {
  value = aws_s3_bucket.demo.bucket
}
