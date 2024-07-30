output "bucket_id" {
  value       = var.create_bucket ? module.bucket[0].id : null
  description = "Bucket ID or Name"
}

output "bucket_arn" {
  value       = var.create_bucket ? module.bucket[0].arn : null
  description = "Bucket ARN"
}

output "destination_buckets" {
  value = var.replication_config.enable ? module.replication[0].destination_buckets : null
}

output "role_arn" {
  value       = var.replication_config.enable ? module.replication[0].role_arn : null
  description = "Role used to S3 replication"
}