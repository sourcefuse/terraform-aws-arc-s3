locals {
  bucket_id           = join("", aws_s3_bucket.this[*].id)
  object_lock_enabled = var.enabled && var.object_lock_configuration != null
  versioning_enabled  = var.enabled && var.versioning_enabled
  partition           = join("", data.aws_partition.current[*].partition)
  bucket_arn          = "arn:${local.partition}:s3:::${local.bucket_id}"
  acl_grants = var.grants == null ? [] : flatten(
    [
      for g in var.grants : [
        for p in g.permissions : {
          id         = g.id
          type       = g.type
          permission = p
          uri        = g.uri
        }
      ]
  ])
  lifecycle_rules = try(jsondecode(var.lifecycle_rule), var.lifecycle_rule)
}
