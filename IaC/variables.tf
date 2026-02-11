variable "bucket_name" {
  description = "The name of the S3 bucket (must be globally unique, lowercase, no spaces)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}