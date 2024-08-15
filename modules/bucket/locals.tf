locals {
  directory_bucket_name = var.create_s3_directory_bucket ? "${aws_s3_bucket.this.id}-${var.availability_zone_id}" : ""
}