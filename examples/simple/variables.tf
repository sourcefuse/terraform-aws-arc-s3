################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "name" {
  type        = string
  description = "Bucket Name"
}

variable "acl" {
  type        = string
  description = "ACL value"
}
