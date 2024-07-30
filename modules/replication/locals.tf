locals {
  environment         = lower(try(var.tags.environment, var.tags.Environment, ""))
  create_role         = var.replication_config.role_name == null ? true : false
  role_arn            = local.create_role ? aws_iam_role.this[0].arn : data.aws_iam_role.this[0].arn
  role_name           = "${local.environment}-${var.source_bucket}-replication-${random_id.this.id}"
  destination_buckets = flatten([for rule in var.replication_config.rules : [for destination in rule.destinations : destination.bucket]])
  dest_replica_kms_key_id_list = flatten([
    for rule in var.replication_config.rules : [
      for destination in rule.destinations : destination.encryption_configuration.replica_kms_key_id
      if destination.encryption_configuration.replica_kms_key_id != null
  ]])


  src_kms_key_ids = flatten([
    for rule in var.replication_config.rules : [
      for source_selection_criteria in [rule.source_selection_criteria] : source_selection_criteria.kms_key_id
      if source_selection_criteria.kms_key_id != null
    ]
  ])


  kms_key_ids = toset(concat(local.dest_replica_kms_key_id_list, local.src_kms_key_ids))
}