output "role_name" {
  value       = local.create_role ? aws_iam_role.this[0].name : var.replication_config.role_name
  description = "Bucket ID or Name"
}

output "role_arn" {
  value       = local.create_role ? aws_iam_role.this[0].arn : data.aws_iam_role.this[0].arn
  description = "Role used to S3 replication"
}

output "destination_buckets" {
  value = local.destination_buckets
}