variable "source_bucket" {
  type        = string
  description = "Source Bucket name"
}

variable "replication_config" {
  type = object({
    enable    = bool
    role_name = optional(string, null) // if null , it will create new role

    rules = list(object({
      id = optional(string, null) // if null "${var.source_bucket_name}-rule-index"
      filter = optional(list(object({
        prefix = optional(string, null)
        tags   = optional(map(string), {})
      })), [])

      delete_marker_replication = optional(string, "Enabled")

      source_selection_criteria = optional(object({
        replica_modifications = optional(object({
          status = optional(string, "Enabled")
        }))
        kms_key_id = optional(string, null)
        sse_kms_encrypted_objects = optional(object({
          status = optional(string, "Enabled")
        }))
      }))


      destinations = list(object({
        bucket        = string
        storage_class = optional(string, "STANDARD")
        encryption_configuration = optional(object({
          replica_kms_key_id = optional(string, null)
        }))
      }))
    }))

  })
  description = "Replication configuration for S3 bucket "
  default = {
    enable    = false
    role_name = null // if null , it will create new role
    rules     = []
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags for aws resources"
  default     = {}
}
