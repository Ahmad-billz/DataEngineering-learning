          ######## ======== ex1 ======== ########

variable "bucket_prefix" {
  description = "Prefix for the S3 bucket (lowercase letters, digits, hyphen; 3-30 chars)"
  type        = string

  validation {
    condition     = length(var.bucket_prefix) >= 3 && length(var.bucket_prefix) <= 30 && can(regex("^[-a-z0-9]+$", var.bucket_prefix))
    error_message = "bucket_prefix must be 3-30 chars and only contain lowercase letters, digits and hyphens."
  }
}