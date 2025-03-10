locals {
  lifecycle_config = {
    enabled = true
    rules = [
      {
        id     = "rule-1"
        status = "Enabled"

        filter = {
          prefix = "logs/"
          tags = {
            environment = "Production"
          }
        }
        transitions = [
          {
            days          = 30
            storage_class = "GLACIER"
          }
        ]
        expiration = {
          days = 365
        }
        noncurrent_version_transitions = [
          {
            newer_noncurrent_versions = 2
            noncurrent_days           = 90
            storage_class             = "GLACIER"
          }
        ]
        noncurrent_version_expiration = {
          newer_noncurrent_versions = 3
          noncurrent_days           = 180
        }
      }
    ]
  }
}
