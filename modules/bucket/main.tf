resource "aws_s3_bucket" "this" {
  bucket        = var.name
  force_destroy = var.force_destroy

  object_lock_enabled = var.object_lock_enabled

  tags = var.tags
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.public_access_config.block_public_acls
  block_public_policy     = var.public_access_config.block_public_policy
  ignore_public_acls      = var.public_access_config.ignore_public_acls
  restrict_public_buckets = var.public_access_config.restrict_public_buckets
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = var.acl

  depends_on = [aws_s3_bucket_ownership_controls.this, aws_s3_bucket_public_access_block.this]
}


resource "aws_s3_bucket_accelerate_configuration" "this" {
  count = var.transfer_acceleration_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id
  status = "Enabled"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_logging" "this" {
  count = var.bucket_logging_data.enable ? 1 : 0

  bucket = aws_s3_bucket.this.id

  target_bucket = var.bucket_logging_data.target_bucket
  target_prefix = var.bucket_logging_data.target_prefix
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = var.server_side_encryption_config_data.bucket_key_enabled

    apply_server_side_encryption_by_default {
      sse_algorithm     = var.server_side_encryption_config_data.sse_algorithm
      kms_master_key_id = var.server_side_encryption_config_data.kms_master_key_id
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  count = aws_s3_bucket.this.object_lock_enabled == "Enabled" ? 1 : 0

  bucket = aws_s3_bucket.this.id

  object_lock_enabled = "Enabled"

  rule {
    default_retention {
      mode = var.object_lock_config.mode
      days = var.object_lock_config.days
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count = length(var.cors_configuration) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "cors_rule" {
    for_each = var.cors_configuration

    content {
      id              = cors_rule.value.id
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count = var.bucket_policy_doc == null ? 0 : 1

  bucket     = aws_s3_bucket.this.id
  policy     = var.bucket_policy_doc
  depends_on = [aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  count  = var.event_notification_details.enabled ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "lambda_function" {
    for_each = var.event_notification_details.lambda_list
    content {
      lambda_function_arn = lambda_function.value.lambda_function_arn
      events              = lambda_function.value.events
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
    }
  }

  dynamic "queue" {
    for_each = var.event_notification_details.queue_list
    content {
      queue_arn = queue.value.queue_arn
      events    = queue.value.events
    }
  }

  dynamic "topic" {
    for_each = var.event_notification_details.topic_list
    content {
      topic_arn = topic.value.topic_arn
      events    = topic.value.events
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.lifecycle_config.enabled ? 1 : 0

  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = var.lifecycle_config.expected_bucket_owner

  dynamic "rule" {
    for_each = var.lifecycle_config.rules

    content {
      id     = rule.value.id
      status = "Enabled"

      // Refer Terrform doc : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration#filter
      #  NOTE:
      # The filter configuration block must either be specified as the empty configuration block (filter {}) or with exactly one of prefix, tag, and, object_size_greater_than or object_size_less_than specified.
      dynamic "filter" {
        for_each = rule.value.filter == null ? [1] : []
        content {}
      }

      dynamic "filter" {
        for_each = rule.value.filter == null ? [] : [rule.value.filter]
        content {
          and {
            object_size_greater_than = rule.value.filter.object_size_greater_than
            object_size_less_than    = rule.value.filter.object_size_less_than
            prefix                   = rule.value.filter.prefix
            tags                     = rule.value.filter.tags
          }
        }
      }

      dynamic "transition" {
        for_each = rule.value.transition == null ? [] : [rule.value.transition]

        content {
          date          = transition.value.date
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration == null ? [] : [rule.value.expiration]

        content {
          date                         = expiration.value.date
          days                         = expiration.value.days
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration == null ? [] : [rule.value.noncurrent_version_expiration]

        content {
          newer_noncurrent_versions = noncurrent_version_expiration.value.newer_noncurrent_versions
          noncurrent_days           = noncurrent_version_expiration.value.noncurrent_days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transition == null ? [] : [rule.value.noncurrent_version_transition]

        content {
          newer_noncurrent_versions = noncurrent_version_transition.value.newer_noncurrent_versions
          noncurrent_days           = noncurrent_version_transition.value.noncurrent_days
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

/// Directory Bucket 
// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_directory_bucket
resource "aws_s3_directory_bucket" "default" {
  count         = var.create_s3_directory_bucket ? 1 : 0
  bucket        = local.directory_bucket_name
  force_destroy = var.force_destroy

  location {
    name = var.availability_zone_id
  }
}