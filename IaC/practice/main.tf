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
# terraform {
#   required_providers {
#     aws    = { source = "hashicorp/aws" }
#     random = { source = "hashicorp/random" }
#   }
# }

# provider "aws" {
#   region = "us-east-1"
# }

# resource "random_id" "suffix" {
#   byte_length = 4
# }

# resource "aws_s3_bucket" "validated" {
#   bucket = "${var.bucket_prefix}-${random_id.suffix.hex}"
#   tags = {
#     Name = var.bucket_prefix
#     Env  = "dev"
#   }
# }

# output "bucket_name" {
#   value = aws_s3_bucket.validated.bucket
# }


# #           ######## ======== ex2 ======== ########
# terraform {
#   required_providers {
#     aws    = { source = "hashicorp/aws" }
#     random = { source = "hashicorp/random" }
#   }
# }

# provider "aws" { region = "us-east-1" }

# resource "random_id" "suffix" {
#   count       = var.count_buckets
#   byte_length = 4
# }

# resource "aws_s3_bucket" "multi" {
#   count  = var.count_buckets
#   bucket = "${var.bucket_prefix}-${random_id.suffix[count.index].hex}"
#   tags = {
#     Name  = var.bucket_prefix
#     Index = tostring(count.index)
#   }
# }

# output "bucket_names" {
#   value = aws_s3_bucket.multi[*].bucket
# }


#             ######## ======== ex3 ======== ########
# terraform {
#   required_providers {
#     aws    = { source = "hashicorp/aws" }
#     local  = { source = "hashicorp/local" }
#     random = { source = "hashicorp/random" }
#   }
# }

# provider "aws" { region = "us-east-1" }
# provider "local" {}

# resource "random_id" "suffix" { byte_length = 4 }

# resource "aws_s3_bucket" "demo" {
#   bucket = "iac-localfile-${random_id.suffix.hex}"

#   tags = {
#     Name = "iac-localfile"
#     Env  = "dev"
#   }
# }

# resource "local_file" "bucket_info" {
#   filename = "bucket-info.txt"
#   content  = <<EOT
# Bucket name: ${aws_s3_bucket.demo.bucket}
# Bucket ARN:  ${aws_s3_bucket.demo.arn}
# EOT
# }

# output "created_file" { value = local_file.bucket_info.filename }


#             ######## ======== ex4 ======== ########
# terraform {
#   required_providers {
#     aws    = { source = "hashicorp/aws" }
#     random = { source = "hashicorp/random" }
#   }
# }
# provider "aws" { region = "us-east-1" }

# resource "random_id" "suf" { byte_length = 4 }

# resource "aws_s3_bucket" "original_bucket" {
#   bucket = "iac-state-sample25-${random_id.suf.hex}"
#   tags = { Name = "iac-state-sample" }
# }

# output "bucket_name" { value = aws_s3_bucket.original_bucket.bucket }



#             ######## ======== ex5 ======== ########
# terraform {
#   required_providers {
#     aws   = { source = "hashicorp/aws" }
#     local = { source = "hashicorp/local" }
#     random = { source = "hashicorp/random" }
#   }
# }
# provider "aws" { region = "us-east-1" }
# provider "local" {}

# resource "random_id" "suf" {
#   count       = 2
#   byte_length = 4
# }

# resource "aws_s3_bucket" "backup" {
#   bucket = "iac-backup-${random_id.suf[0].hex}"
#   tags = { Name = "backup" }
# }

# resource "aws_s3_bucket" "archive" {
#   bucket = "iac-archive-${random_id.suf[1].hex}"
#   tags = { Name = "archive" }
# }

# output "bucket_arns_map" {
#   value = {
#     backup  = aws_s3_bucket.backup.arn
#     archive = aws_s3_bucket.archive.arn
#   }
# }

# resource "local_file" "buckets_json" {
#   filename = "buckets.json"
#   content  = jsonencode({
#     backup  = aws_s3_bucket.backup.arn
#     archive = aws_s3_bucket.archive.arn
#   })
# }


            ######## ======== ex6 ======== ########
# terraform {
#   required_providers {
#     aws    = { source = "hashicorp/aws" }
#     random = { source = "hashicorp/random" }
#   }
# }
# provider "aws" { region = "us-east-1" }

# data "aws_caller_identity" "current" {}

# resource "random_id" "sfx" { byte_length = 2 }

# locals {
#   acct_id = data.aws_caller_identity.current.account_id
#   last4   = substr(local.acct_id, length(local.acct_id) - 4, 4)
# }

# resource "aws_s3_bucket" "acct_bucket" {
#   bucket = "iac-${local.last4}-${random_id.sfx.hex}"
#   tags = { Account = local.acct_id }
# }

# output "aws_account_id" { value = data.aws_caller_identity.current.account_id }
# output "bucket_name" { value = aws_s3_bucket.acct_bucket.bucket }



#             ######## ======== ex7 ======== ########
# terraform {
#   required_providers {
#     aws = { source = "hashicorp/aws" }
#   }
# }
# provider "aws" { region = "us-east-1" }

# resource "aws_s3_bucket" "imported" {
#   bucket = "iac-manual-import-REPLACE_WITH_SUFFIX"
#   tags = { ManagedBy = "terraform-import-exercise" }
# }

# output "bucket_name" { value = aws_s3_bucket.imported.bucket }



#             ######## ======== ex8 ======== ########
# terraform {
#   required_providers {
#     aws    = { source = "hashicorp/aws" }
#     random = { source = "hashicorp/random" }
#   }
# }
# provider "aws" { region = "us-east-1" }

# resource "random_id" "s" { byte_length = 4 }

# resource "aws_s3_bucket" "protected" {
#   bucket = "iac-protected-${random_id.s.hex}"
#   tags = { Name = "iac-protected" }
#   lifecycle { prevent_destroy = true }
# }
# output "bucket_name" { value = aws_s3_bucket.protected.bucket }



#             ######## ======== ex9 ======== ########
terraform {
  required_providers {
    aws    = { source = "hashicorp/aws" }
    random = { source = "hashicorp/random" }
  }
}
provider "aws" { region = "us-east-1" }

resource "random_id" "s" { byte_length = 4 }

resource "aws_s3_bucket" "recreate" {
  bucket = "iac-taint-${random_id.s.hex}"
  tags = { Name = "iac-taint-demo" }
}
output "bucket_name" { value = aws_s3_bucket.recreate.bucket }

#######
provider "aws" {
  region = "us-east-1"
}

module "mybucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "terraform-module-bucket-2991" # CHANGE to a globally unique name
  # acl removed — we won't manage ACLs (preferred)
  tags = {
    owner = "you"
    env   = "dev"
  }
}

output "bucket_id" {
  value = module.mybucket.bucket_id
}
