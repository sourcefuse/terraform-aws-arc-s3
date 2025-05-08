################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

# variable "name" {
#   type        = string
#   description = "Bucket Name"
#   default     = "arc-unique-randome-bucket-05052025"
# }

variable "acl" {
  type        = string
  description = "ACL value"
  default     =  "private"
}
