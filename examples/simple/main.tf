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

# Generate random name suffix
resource "random_pet" "bucket_suffix" {
  length    = 2
  separator = "-"
}

module "s3" {
  source           = "../../"
  name             = "my-app-${random_pet.bucket_suffix.id}"
  acl              = var.acl
  # lifecycle_config = local.lifecycle_config
  tags             = module.tags.tags
}
