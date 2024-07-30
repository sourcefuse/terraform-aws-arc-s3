// Do not use data source to get arn of buckets , instead use s3 arn format

data "aws_iam_role" "this" {
  count = local.create_role ? 0 : 1
  name  = var.replication_config.role_name
}

data "aws_kms_key" "this" {
  for_each = local.kms_key_ids
  key_id   = each.value
}
