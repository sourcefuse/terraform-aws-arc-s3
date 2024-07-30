resource "aws_s3_bucket_replication_configuration" "this" {
  role   = local.role_arn
  bucket = var.source_bucket

  dynamic "rule" {
    for_each = var.replication_config.rules

    content {
      status = "Enabled"
      id     = "${var.source_bucket}-${rule.key}"

      dynamic "filter" {
        for_each = rule.value.filter

        content {
          prefix = filter.value.prefix
          dynamic "tag" {
            for_each = try(filter.value.tags, {})

            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }

      // Amazon S3's latest version of the replication configuration is V2, which includes the filter attribute for replication rules.
      filter {}

      dynamic "delete_marker_replication" {
        for_each = rule.value.delete_marker_replication == "Enabled" ? [1] : []
        content {
          status = rule.value.delete_marker_replication
        }
      }

      dynamic "destination" {
        for_each = rule.value.destinations

        content {
          bucket        = "arn:aws:s3:::${destination.value.bucket}"
          storage_class = destination.value.storage_class

          dynamic "encryption_configuration" {
            for_each = destination.value.encryption_configuration.replica_kms_key_id == null ? [] : [1]
            content {
              replica_kms_key_id = destination.value.encryption_configuration.replica_kms_key_id
            }
          }

        }

      }


      source_selection_criteria {
        replica_modifications {
          status = rule.value.source_selection_criteria.replica_modifications.status
        }

        dynamic "sse_kms_encrypted_objects" {
          for_each = rule.value.source_selection_criteria.sse_kms_encrypted_objects.status == "Enabled" ? [1] : []
          content {
            status = rule.value.source_selection_criteria.sse_kms_encrypted_objects.status
          }
        }

      }

    }
  }
}
