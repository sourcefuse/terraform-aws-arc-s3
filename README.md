![Module Structure](./static/s3.png)

# [terraform-aws-arc-s3](https://github.com/sourcefuse/terraform-aws-arc-s3)

<a href="https://github.com/sourcefuse/terraform-aws-arc-s3/releases/latest"><img src="https://img.shields.io/github/release/sourcefuse/terraform-aws-arc-s3.svg?style=for-the-badge" alt="Latest Release"/></a> <a href="https://github.com/sourcefuse/terraform-aws-arc-s3/commits"><img src="https://img.shields.io/github/last-commit/sourcefuse/terraform-aws-arc-s3.svg?style=for-the-badge" alt="Last Updated"/></a> ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) ![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

[![Quality gate](https://sonarcloud.io/api/project_badges/quality_gate?project=sourcefuse_terraform-aws-arc-s3&token=3c75a1b94d1b6ab3f1b98785e484d5ede197851e)](https://sonarcloud.io/summary/new_code?id=sourcefuse_terraform-aws-arc-s3)

[![Known Vulnerabilities](https://github.com/sourcefuse/terraform-aws-arc-s3/actions/workflows/snyk.yaml/badge.svg)](https://github.com/sourcefuse/terraform-aws-arc-s3/actions/workflows/snyk.yaml)

## Overview

SourceFuse AWS Reference Architecture (ARC) Terraform module for managing the s3 module.

## Features
 - Manages S3 buckets.
 - Supports lifecycle rules.
 - Configurable bucket policies and access controls.
 - Supports CORS and website configurations.

## Introduction

SourceFuse's AWS Reference Architecture (ARC) Terraform module for managing S3 buckets centralizes and automates the deployment and management of S3 resources. This module helps you create and manage S3 buckets with options for lifecycle policies, access control lists (ACLs), and CORS configurations. It integrates with other AWS services, ensuring secure, scalable, and efficient storage solutions. The module supports various configurations, providing a robust solution for your storage needs across different environments.

## Usage

To see a full example, check out the [main.tf](./example/main.tf) file in the example folder.  

```hcl
module "arc-s3" {
  source = "../"
  bucket_name = var.bucket_name
  enable_notifications = var.enable_notifications
  enabled = var.enabled
  bucket_key_enabled = var.bucket_key_enabled
  acl = var.acl
  lifecycle_rule = local.lifecycle_rule
  website_configuration = var.website_configuration
  cors_configuration = var.cors_configuration
  allowed_bucket_actions = var.allowed_bucket_actions
  tags = module.tags.tags
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
 
## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
  ```sh
  pre-commit install
  ```

### Versioning

while Contributing or doing git commit please specify the breaking change in your commit message whether its major,minor or patch

For Example

```sh
git commit -m "your commit message #major"
```
By specifying this , it will bump the version and if you don't specify this in your commit message then by default it will consider patch and will bump that accordingly

### Tests
- Tests are available in `test` directory
- Configure the dependencies
  ```sh
  cd test/
  go mod init github.com/sourcefuse/terraform-aws-refarch-<module_name>
  go get github.com/gruntwork-io/terratest/modules/terraform
  ```
- Now execute the test  
  ```sh
  go test -timeout  30m
  ```

## Authors

This project is authored by:
- SourceFuse ARC Team
