module "bucket" {
  source = "./modules/bucket"

  count = var.create_bucket ? 1 : 0

  name                               = var.name
  object_lock_enabled                = var.object_lock_enabled
  object_ownership                   = var.object_ownership
  acl                                = var.acl
  public_access_config               = var.public_access_config
  force_destroy                      = var.force_destroy
  enable_versioning                  = var.enable_versioning
  bucket_logging_data                = var.bucket_logging_data
  server_side_encryption_config_data = var.server_side_encryption_config_data
  object_lock_config                 = var.object_lock_config
  cors_configuration                 = var.cors_configuration
  bucket_policy_doc                  = var.bucket_policy_doc
  event_notification_details         = var.event_notification_details
  lifecycle_config                   = var.lifecycle_config
  transfer_acceleration_enabled      = var.transfer_acceleration_enabled
  tags                               = var.tags
}

module "replication" {
  source             = "./modules/replication"
  count              = var.replication_config.enable ? 1 : 0
  source_bucket      = var.name
  replication_config = var.replication_config

  tags = var.tags
}
