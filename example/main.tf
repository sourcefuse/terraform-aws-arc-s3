################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.3, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0, < 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}
module "tags" {
  source      = "sourcefuse/arc-tags/aws"
  version     = "1.2.3"
  environment = "poc"
  project     = "arc"

  extra_tags = {
    RepoName = "terraform-aws-arc-s3"
  }
}

module "arc-s3" {
  source                = "../"
  bucket_name           = var.bucket_name
  enable_notifications  = var.enable_notifications
  bucket_key_enabled    = var.bucket_key_enabled
  acl                   = var.acl
  lifecycle_rule        = local.lifecycle_rule
  website_configuration = var.website_configuration
  cors_configuration    = var.cors_configuration
  tags                  = module.tags.tags
}
