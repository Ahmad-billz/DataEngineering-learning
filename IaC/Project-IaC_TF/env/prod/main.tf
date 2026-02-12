terraform {
  backend "s3" {
    bucket         = "terraform-with-actions-bucket007"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-with-actions-locks-1234"
    encrypt        = true
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "app_bucket" {
  source           = "../../modules/s3_bucket"
  bucket_name      = "myapp-${terraform.workspace}-bucket-${random_id.suffix.hex}"
  enable_versioning = false
  tags = { env = terraform.workspace }
}

