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
}

variable "dest_bucket_name" {
  type        = string
  description = "Destination Bucket Name"
}

variable "acl" {
  type        = string
  description = "ACL value"
}
