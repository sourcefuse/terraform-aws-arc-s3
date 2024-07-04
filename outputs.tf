output "bucket_id" {
  value       = local.bucket_id
  description = "Bucket Name (aka ID)"
}

output "bucket_arn" {
  value       = format("%s", [for arn in aws_s3_bucket.this[*].arn : arn]...)
  description = "Bucket ARN"
}

output "bucket_region" {
  value       = format("%s", [for region in aws_s3_bucket.this[*].region : region]...)
  description = "Bucket region"
}
