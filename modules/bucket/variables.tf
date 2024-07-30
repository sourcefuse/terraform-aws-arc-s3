variable "create_bucket" {
  type        = bool
  description = "(optional) Whether to create bucket"
  default     = true
}

variable "name" {
  type        = string
  description = "Bucket name. If provided, the bucket will be created with this name instead of generating the name from the context"
}

variable "object_lock_enabled" {
  type        = string
  description = "(Optional, Forces new resource) Indicates whether this bucket has an Object Lock configuration enabled. Valid values are true or false. This argument is not supported in all regions or partitions."
  default     = false
}

variable "object_ownership" {
  type        = string
  description = <<-EOT
   (Optional) Object ownership. Valid values: BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced
    BucketOwnerPreferred - Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL.
    ObjectWriter - Uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL.
    BucketOwnerEnforced - Bucket owner automatically owns and has full control over every object in the bucket. ACLs no longer affect permissions to data in the S3 bucket.
  EOT
  default     = "BucketOwnerPreferred"
}

variable "acl" {
  type        = string
  default     = "private"
  description = <<-EOT
    Please node ACL is deprecated by AWS in favor of bucket policies.
    Defaults to "private" for backwards compatibility,recommended to set `s3_object_ownership` to "BucketOwnerEnforced" instead.
  EOT
}

variable "public_access_config" {
  type = object({
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
  })
  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
  description = <<-EOT
  (Optional) 
  block_public_acls - Whether Amazon S3 should block public ACLs for this bucket. Defaults to false. Enabling this setting does not affect existing policies or ACLs. When set to true causes the following behavior:
    PUT Bucket acl and PUT Object acl calls will fail if the specified ACL allows public access.
    PUT Object calls will fail if the request includes an object ACL.
  block_public_policy - Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy.
    When set to true causes Amazon S3 to:
    Reject calls to PUT Bucket policy if the specified bucket policy allows public access.
  ignore_public_acls - Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy.
    When set to true causes Amazon S3 to:
    Reject calls to PUT Bucket policy if the specified bucket policy allows public access.
  restrict_public_buckets - Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy.
    When set to true causes Amazon S3 to:
    Reject calls to PUT Bucket policy if the specified bucket policy allows public access.
  EOT
}

variable "force_destroy" {
  type        = bool
  description = <<-EOT
    (Optional, Default:false) Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. This only deletes objects when the bucket is destroyed, not when setting this parameter to true. Once this parameter is set to true, there must be a successful terraform apply run before a destroy is required to update this value in the resource state. Without a successful terraform apply after this parameter is set, this flag will have no effect. If setting this field in the same operation that would require replacing the bucket or destroying the bucket, this flag will not work. Additionally when importing a bucket, a successful terraform apply is required to set this value in state before it will take effect on a destroy operation.
    EOT
  default     = false
}

variable "enable_versioning" {
  type        = bool
  default     = true
  description = "Whether to enable versioning for the bucket"
}

variable "bucket_logging_data" {
  type = object({
    enable        = optional(bool, false)
    target_bucket = optional(string, null)
    target_prefix = optional(string, null)
  })
  description = "(optional) Bucket logging data"
  default = {
    enable        = false
    target_bucket = null
    target_prefix = null
  }
}

variable "server_side_encryption_config_data" {
  type = object({
    bucket_key_enabled = optional(bool, true)
    sse_algorithm      = optional(string, "AES256")
    kms_master_key_id  = optional(string, null)
  })
  description = "(optional) S3 encryption details"
  default = {
    bucket_key_enabled = true
    sse_algorithm      = "AES256"
    kms_master_key_id  = null
  }
}

variable "object_lock_config" {
  type = object({
    mode = optional(string, "COMPLIANCE")
    days = optional(number, 30)
  })
  description = "(optional) Object Lock configuration"
  default = {
    mode = "COMPLIANCE"
    days = 30
  }
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
  description = "List of S3 bucket CORS configurations"
  default     = []
}

variable "bucket_policy_doc" {
  type        = string
  description = "(optional) S3 bucket Policy doc"
  default     = null
}

variable "event_notification_details" {
  type = object({
    enabled = bool
    lambda_list = optional(list(object({
      lambda_function_arn = string
      events              = optional(list(string), ["s3:ObjectCreated:*"])
      filter_prefix       = string
      filter_suffix       = string
    })), [])

    queue_list = optional(list(object({
      queue_arn = string
      events    = optional(list(string), ["s3:ObjectCreated:*"])
    })), [])

    topic_list = optional(list(object({
      topic_arn = string
      events    = optional(list(string), ["s3:ObjectCreated:*"])
    })), [])

  })
  description = "(optional) S3 event notification details"
  default = {
    enabled = false
  }
}

variable "lifecycle_config" {
  type = object({
    enabled = bool

    expected_bucket_owner = optional(string, null)

    rules = list(object({
      id = string

      expiration = optional(object({
        date                         = string
        days                         = number
        expired_object_delete_marker = bool
      }), null)
      transition = optional(object({
        date          = string
        days          = number
        storage_class = string
      }), null)
      noncurrent_version_expiration = optional(object({
        newer_noncurrent_versions = number
        noncurrent_days           = number
      }), null)
      noncurrent_version_transition = optional(object({
        newer_noncurrent_versions = number
        noncurrent_days           = number
        storage_class             = string
      }), null)

      filter = optional(object({
        object_size_greater_than = string
        object_size_less_than    = string
        prefix                   = string
        tags                     = map(string)
      }), null)


    }))

  })

  description = "(optional) S3 Lifecycle configuration"
  default = {
    enabled = false
    rules   = []
  }
}

variable "tags" {
  description = "Tags to assign the resources."
  type        = map(string)
  default     = {}
}

variable "transfer_acceleration_enabled" {
  type        = bool
  description = "(optional) Whether to enable Trasfer accelaration"
  default     = false
}