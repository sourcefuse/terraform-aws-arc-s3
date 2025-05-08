################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "src_bucket_name" {
  type        = string
  description = "Source Bucket Name"
  default     = "src--bucket"
}

variable "dest_bucket_name" {
  type        = string
  description = "Destination Bucket Name"
  default     = "dest-random-bucket-08-5-2025"
}

variable "acl" {
  type        = string
  description = "ACL value"
  default     = "private"
}
