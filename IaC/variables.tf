#           ######## ======== ex1 ======== ########

# variable "bucket_prefix" {
#   description = "Prefix for the S3 bucket (lowercase letters, digits, hyphen; 3-30 chars)"
#   type        = string

#   validation {
#     condition     = length(var.bucket_prefix) >= 3 && length(var.bucket_prefix) <= 30 && can(regex("^[-a-z0-9]+$", var.bucket_prefix))
#     error_message = "bucket_prefix must be 3-30 chars and only contain lowercase letters, digits and hyphens."
#   }
# }

#            ######## ======== ex2 ======== ########
# variable "bucket_prefix" {
#   type    = string
#   default = "iac-multi"
# }

# variable "count_buckets" {
#   type    = number
#   default = 2
#   validation {
#     condition     = var.count_buckets >= 1 && var.count_buckets <= 5
#     error_message = "count_buckets must be between 1 and 5."
#   }
# }

            ######## ======== ex3 ======== ########