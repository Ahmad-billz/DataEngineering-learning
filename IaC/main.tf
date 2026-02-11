/*             ######## ======== Create s3 bucket ======== ########

terraform {
  required_providers {
    aws    = { source = "hashicorp/aws" }     # AWS provider for infra
    random = { source = "hashicorp/random" }  # Random provider for unique IDs
  }
}

provider "aws" {
  region = "us-east-1"   # Target AWS region
}

# Generate random hex suffix (8 chars) for uniqueness
resource "random_id" "suffix" {
  byte_length = 4
}

# Create S3 bucket with unique name + tags
resource "aws_s3_bucket" "demo" {
  bucket = "iac-demo-${random_id.suffix.hex}"  # final name like iac-demo-1a2b3c4d

  tags = {
    Name = "iac-demo"   # project identifier
    Env  = "dev"        # environment tag
  }

  # force_destroy = true   # (optional) auto-delete bucket + objects on destroy
}

# Output the bucket name for reference/automation
output "bucket_name" {
  value = aws_s3_bucket.demo.bucket
}
 */


#              ######## ======== iac-providers-resources ======== ########
# terraform {
#   required_providers {
#     local = {
#       source  = "hashicorp/local"
#       version = "~> 2.0"
#     }
#   }
# }

# provider "local" {}

# resource "local_file" "demo" {
#   content  = "Hello from Terraform"
#   filename = "hello.txt"
# }


#               ######## ======== iac-providers-resources ======== ########
# provider "aws" {
#   region = "us-east-1"
# }

# # Base bucket
# resource "aws_s3_bucket" "name" {
#   bucket = "iac-demo-bucket-99887711"
#   force_destroy = true
# }

# # File that depends on the bucket (fixed: aws_s3_object instead of aws_s3_bucket_object)
# resource "aws_s3_object" "readme" {
#   bucket  = aws_s3_bucket.name.bucket  # use .bucket for name
#   key     = "README.txt"               # object name in S3
#   content = "This file was provisioned by Terraform"
# }


#               ######## ======== terraform_state ======== ########

# provider "aws" {
#   region = "us-east-1"
# }

# resource "aws_s3_bucket" "demo" {
#   bucket = "iac-state-bucket-11122112299887788"

#   tags = {
#     Name = "iac-demo"
#     Env  = "dev"
#   }
# }



#           ######## ======== terraform variable & outputs ======== ########
# terraform {
#   required_providers {
#     aws    = { source = "hashicorp/aws" }
#     random = { source = "hashicorp/random" }
#   }
# }

# provider "aws" {
#   region = var.aws_region
# }

# # generate short random suffix to avoid collisions in examples
# resource "random_id" "suffix" {
#   byte_length = 4
# }

# # S3 bucket resource (do NOT use ACLs)
# resource "aws_s3_bucket" "demo" {
#   bucket = "${var.bucket_name}-${random_id.suffix.hex}"

#   tags = {
#     Name = var.bucket_name
#     Env  = terraform.workspace
#   }

#   # optional: allow destroying non-empty buckets during destroy (use carefully)
#   force_destroy = true
# }


          ######## ======== ex1 ======== ########
terraform {
  required_providers {
    aws    = { source = "hashicorp/aws" }
    random = { source = "hashicorp/random" }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "validated" {
  bucket = "${var.bucket_prefix}-${random_id.suffix.hex}"
  tags = {
    Name = var.bucket_prefix
    Env  = "dev"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.validated.bucket
}