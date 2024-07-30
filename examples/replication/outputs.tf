output "src_bucket_id" {
  value = module.src_bucket.bucket_id
}

output "src_bucket_arn" {
  value = module.src_bucket.bucket_arn
}

output "dest_bucket_id" {
  value = module.dest_bucket.bucket_id
}

output "dest_bucket_arn" {
  value = module.dest_bucket.bucket_arn
}

output "destination_buckets" {
  value = module.replication.destination_buckets
}

output "role_arn" {
  value       = module.replication.role_arn
  description = "Role used to S3 replication"
}
