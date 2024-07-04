locals {
  bucket_id           = format("%s", [for id in aws_s3_bucket.this[*].id : id]...)
  partition           = format("%s", [for part in data.aws_partition.current[*].partition : part]...)
  object_lock_enabled = var.object_lock_configuration != null
  versioning_enabled  = var.versioning_enabled
  bucket_arn          = "arn:${local.partition}:s3:::${local.bucket_id}" // required for bucket policy and being used in data lookups
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
