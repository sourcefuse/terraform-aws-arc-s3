resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  object_lock_enabled = local.object_lock_enabled

  tags = var.tags
}

resource "aws_s3_bucket_accelerate_configuration" "default" {
  count = var.transfer_acceleration_enabled ? 1 : 0

  bucket = local.bucket_id
  status = "Enabled"
}

# Ensure the resource exists to track drift, even if the feature is disabled
resource "aws_s3_bucket_versioning" "this" {

  bucket = local.bucket_id

  versioning_configuration {
    status = local.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_logging" "default" {
  for_each = toset(var.enabled && length(var.logging) > 0 ? ["enabled"] : [])

  bucket = local.bucket_id

  target_bucket = var.logging[0]["bucket_name"]
  target_prefix = var.logging[0]["prefix"]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {

  bucket = local.bucket_id

  rule {
    bucket_key_enabled = var.bucket_key_enabled

    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_master_key_arn
    }
  }
}

resource "aws_s3_bucket_website_configuration" "default" {
  count = (try(length(var.website_configuration), 0) > 0) ? 1 : 0

  bucket = local.bucket_id

  dynamic "index_document" {
    for_each = try(length(var.website_configuration[0].index_document), 0) > 0 ? [true] : []
    content {
      suffix = var.website_configuration[0].index_document
    }
  }

  dynamic "error_document" {
    for_each = try(length(var.website_configuration[0].error_document), 0) > 0 ? [true] : []
    content {
      key = var.website_configuration[0].error_document
    }
  }

  dynamic "routing_rule" {
    for_each = try(length(var.website_configuration[0].routing_rules), 0) > 0 ? var.website_configuration[0].routing_rules : []
    content {
      dynamic "condition" {
        // Test for null or empty strings
        for_each = try(length(routing_rule.value.condition.http_error_code_returned_equals), 0) + try(length(routing_rule.value.condition.key_prefix_equals), 0) > 0 ? [true] : []
        content {
          http_error_code_returned_equals = routing_rule.value.condition.http_error_code_returned_equals
          key_prefix_equals               = routing_rule.value.condition.key_prefix_equals
        }
      }

      redirect {
        host_name               = routing_rule.value.redirect.host_name
        http_redirect_code      = routing_rule.value.redirect.http_redirect_code
        protocol                = routing_rule.value.redirect.protocol
        replace_key_prefix_with = routing_rule.value.redirect.replace_key_prefix_with
        replace_key_with        = routing_rule.value.redirect.replace_key_with
      }
    }
  }
}

// The "redirect_all_requests_to" block is mutually exclusive with all other blocks,
// any trying to switch from one to the other will cause a conflict.
resource "aws_s3_bucket_website_configuration" "redirect" {
  count = (try(length(var.website_redirect_all_requests_to), 0) > 0) ? 1 : 0

  bucket = local.bucket_id

  redirect_all_requests_to {
    host_name = var.website_redirect_all_requests_to[0].host_name
    protocol  = var.website_redirect_all_requests_to[0].protocol
  }
}

resource "aws_s3_bucket_cors_configuration" "default" {
  count = try(length(var.cors_configuration), 0) > 0 ? 1 : 0

  bucket = local.bucket_id

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
resource "aws_s3_bucket_acl" "default" {
  count = var.s3_object_ownership != "BucketOwnerEnforced" ? 1 : 0

  bucket = local.bucket_id

  # Conflicts with access_control_policy so this is enabled if no grants
  acl = try(length(local.acl_grants), 0) == 0 ? var.acl : null

  dynamic "access_control_policy" {
    for_each = try(length(local.acl_grants), 0) == 0 || try(length(var.acl), 0) > 0 ? [] : [1]

    content {
      dynamic "grant" {
        for_each = local.acl_grants

        content {
          grantee {
            id   = grant.value.id
            type = grant.value.type
            uri  = grant.value.uri
          }
          permission = grant.value.permission
        }
      }

      owner {
        id = one(data.aws_canonical_user_id.default[*].id)
      }
    }
  }
  depends_on = [aws_s3_bucket_ownership_controls.this]
}
resource "aws_s3_bucket_object_lock_configuration" "default" {
  count = local.object_lock_enabled ? 1 : 0

  bucket = local.bucket_id

  object_lock_enabled = "Enabled"

  rule {
    default_retention {
      mode  = var.object_lock_configuration.mode
      days  = var.object_lock_configuration.days
      years = var.object_lock_configuration.years
    }
  }
}

resource "aws_s3_bucket_policy" "default" {
  count = (
    var.allow_ssl_requests_only ||
    var.allow_encrypted_uploads_only ||
    length(var.s3_replication_source_roles) > 0 ||
    length(var.privileged_principal_arns) > 0 ||
    length(var.source_policy_documents) > 0
  ) ? 1 : 0

  bucket     = local.bucket_id
  policy     = one(data.aws_iam_policy_document.aggregated_policy[*].json)
  depends_on = [aws_s3_bucket_public_access_block.default]
}
resource "aws_s3_bucket_public_access_block" "default" {

  bucket = local.bucket_id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# Per https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html
resource "aws_s3_bucket_ownership_controls" "this" {

  bucket = local.bucket_id

  rule {
    object_ownership = var.s3_object_ownership
  }
  depends_on = [time_sleep.wait_for_aws_s3_bucket_settings]
}

# Workaround S3 eventual consistency for settings objects
resource "time_sleep" "wait_for_aws_s3_bucket_settings" {

  depends_on       = [aws_s3_bucket_public_access_block.default]
  create_duration  = "30s"
  destroy_duration = "30s"
}

# Event Notifications
resource "aws_s3_bucket_notification" "bucket_notification" {
  count  = var.enable_notifications ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "lambda_function" {
    for_each = var.enable_notifications && var.notification_type == "lambda" ? [var.lambda_function] : []
    content {
      lambda_function_arn = lambda_function.value.arn
      events              = ["s3:ObjectCreated:*"]
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
    }
  }

  dynamic "queue" {
    for_each = var.enable_notifications && var.notification_type == "queue" ? [var.queue_arn] : []
    content {
      queue_arn = queue.value
      events    = ["s3:ObjectCreated:*"]
    }
  }

  dynamic "topic" {
    for_each = var.enable_notifications && var.notification_type == "topic" ? [var.topic_arn] : []
    content {
      topic_arn = topic.value
      events    = ["s3:ObjectCreated:*"]
    }
  }
}

# Lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = length(local.lifecycle_rules) > 0 ? 1 : 0

  bucket                = local.bucket_id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "rule" {
    for_each = local.lifecycle_rules

    content {
      id     = try(rule.value.id, null)
      status = try(rule.value.enabled ? "Enabled" : "Disabled", tobool(rule.value.status) ? "Enabled" : "Disabled", title(lower(rule.value.status)))

      # Max 1 block - abort_incomplete_multipart_upload
      dynamic "abort_incomplete_multipart_upload" {
        for_each = try([rule.value.abort_incomplete_multipart_upload_days], [])

        content {
          days_after_initiation = try(rule.value.abort_incomplete_multipart_upload_days, null)
        }
      }


      # Max 1 block - expiration
      dynamic "expiration" {
        for_each = try(flatten([rule.value.expiration]), [])

        content {
          date                         = try(expiration.value.date, null)
          days                         = try(expiration.value.days, null)
          expired_object_delete_marker = try(expiration.value.expired_object_delete_marker, null)
        }
      }

      # Several blocks - transition
      dynamic "transition" {
        for_each = try(flatten([rule.value.transition]), [])

        content {
          date          = try(transition.value.date, null)
          days          = try(transition.value.days, null)
          storage_class = transition.value.storage_class
        }
      }

      # Max 1 block - noncurrent_version_expiration
      dynamic "noncurrent_version_expiration" {
        for_each = try(flatten([rule.value.noncurrent_version_expiration]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_expiration.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_expiration.value.days, noncurrent_version_expiration.value.noncurrent_days, null)
        }
      }

      # Several blocks - noncurrent_version_transition
      dynamic "noncurrent_version_transition" {
        for_each = try(flatten([rule.value.noncurrent_version_transition]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_transition.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_transition.value.days, noncurrent_version_transition.value.noncurrent_days, null)
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }
      # Max 1 block - filter - with one key argument or a single tag
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) == 1]

        content {
          object_size_greater_than = try(filter.value.object_size_greater_than, null)
          object_size_less_than    = try(filter.value.object_size_less_than, null)
          prefix                   = try(filter.value.prefix, null)

          dynamic "tag" {
            for_each = try(filter.value.tags, filter.value.tag, [])

            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }

      # Max 1 block - filter - with more than one key arguments or multiple tags
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) > 1]

        content {
          and {
            object_size_greater_than = try(filter.value.object_size_greater_than, null)
            object_size_less_than    = try(filter.value.object_size_less_than, null)
            prefix                   = try(filter.value.prefix, null)
            tags                     = try(filter.value.tags, filter.value.tag, null)
          }
        }
      }
    }
  }

  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.this]
}
