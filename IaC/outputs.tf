output "bucket_name" {
  description = "The actual bucket name created"
  value       = aws_s3_bucket.demo.bucket
}

output "bucket_arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.demo.arn
}