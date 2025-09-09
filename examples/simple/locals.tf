locals {
  lifecycle_config = {
    enabled = true
    rules = [
      {
        id     = "rule-1"
        status = "Enabled"
        expiration = {
          days = 30
        }
        transition = {
          days          = 180
          storage_class = "GLACIER"
        }
        noncurrent_version_expiration = {
          newer_noncurrent_versions = 2
          noncurrent_days           = 200
        }
        noncurrent_version_transition = {
          newer_noncurrent_versions = 2
          noncurrent_days           = 30
          storage_class             = "STANDARD_IA"
        }
        filter = {
          object_size_greater_than = "131072"
          object_size_less_than    = "1000000"
          prefix                   = "logs/"
          tags = {
            "environment" = "production"
            "department"  = "IT"
          }
        }
      }
    ]
  }
}
