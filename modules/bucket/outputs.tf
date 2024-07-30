output "id" {
  value       = aws_s3_bucket.this.id
  description = "Bucket ID or Name"
}

output "arn" {
  value       = aws_s3_bucket.this.arn
  description = "Bucket ARN"
}
