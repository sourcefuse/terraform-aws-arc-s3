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

provider "aws" {
  region = var.region
  alias  = "src"
}

provider "aws" {
  region = "us-east-2"
  alias  = "dest"
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

module "src_bucket" {
  source = "../../"
  name   = var.src_bucket_name
  acl    = var.acl
  tags   = module.tags.tags

  providers = {
    aws = aws.src
  }
}

module "dest_bucket" {
  source = "../../"
  name   = var.dest_bucket_name
  acl    = var.acl
  tags   = module.tags.tags

  providers = {
    aws = aws.dest
  }
}

module "replication" {
  source             = "../../"
  create_bucket      = false
  name               = var.src_bucket_name
  replication_config = local.replication_config
  tags               = module.tags.tags

  depends_on = [module.src_bucket, module.dest_bucket]
}