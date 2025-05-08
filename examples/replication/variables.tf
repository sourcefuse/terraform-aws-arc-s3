################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

# variable "src_bucket_name" {
#   type        = string
#   description = "Source Bucket Name"
#   default     = "src-randome-bucket-05052025"
# }

# variable "dest_bucket_name" {
#   type        = string
#   description = "Destination Bucket Name"
#   default     = "unique-randome-bucket-05052025"
# }

variable "acl" {
  type        = string
  description = "ACL value"
  default         = "private"
}
