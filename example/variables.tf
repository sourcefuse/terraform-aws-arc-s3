################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}
variable "cors_configuration" {
  type = list(object({
    id              = optional(string)
    allowed_headers = optional(list(string))
    allowed_methods = optional(list(string))
    allowed_origins = optional(list(string))
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  description = "Specifies the allowed headers, methods, origins and exposed headers when using CORS on this bucket"
  default     = []
}
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "enable_notifications" {
  description = "Enable or disable notifications for the S3 bucket"
  type        = bool
  default     = false
}

variable "enabled" {
  description = "Enable or disable the S3 bucket"
  type        = bool
  default     = true
}

variable "bucket_key_enabled" {
  description = "Enable or disable bucket key for the S3 bucket"
  type        = bool
  default     = true
}

variable "acl" {
  description = "The ACL for the S3 bucket"
  type        = string
  default     = "private"
}

variable "website_configuration" {
  description = "The website configuration for the S3 bucket"
  type        = list(any)
  default     = []
}
