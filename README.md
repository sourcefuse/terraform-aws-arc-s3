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
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.11.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.11.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_accelerate_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration) | resource |
| [aws_s3_bucket_acl.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_object_lock_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_bucket_website_configuration.redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [time_sleep.wait_for_aws_s3_bucket_settings](https://registry.terraform.io/providers/hashicorp/time/0.11.2/docs/resources/sleep) | resource |
| [aws_canonical_user_id.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |
| [aws_iam_policy_document.aggregated_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | The [canned ACL](https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl) to apply.<br>Deprecated by AWS in favor of bucket policies.<br>Automatically disabled if `s3_object_ownership` is set to "BucketOwnerEnforced".<br>Defaults to "private" for backwards compatibility, but we recommend setting `s3_object_ownership` to "BucketOwnerEnforced" instead. | `string` | `"private"` | no |
| <a name="input_allow_encrypted_uploads_only"></a> [allow\_encrypted\_uploads\_only](#input\_allow\_encrypted\_uploads\_only) | Set to `true` to prevent uploads of unencrypted objects to S3 bucket | `bool` | `false` | no |
| <a name="input_allow_ssl_requests_only"></a> [allow\_ssl\_requests\_only](#input\_allow\_ssl\_requests\_only) | Set to `true` to require requests to use Secure Socket Layer (HTTPS/SSL). This will explicitly deny access to HTTP requests | `bool` | `false` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Set to `false` to disable the blocking of new public access lists on the bucket | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Set to `false` to disable the blocking of new public policies on the bucket | `bool` | `true` | no |
| <a name="input_bucket_key_enabled"></a> [bucket\_key\_enabled](#input\_bucket\_key\_enabled) | Set this to true to use Amazon S3 Bucket Keys for SSE-KMS, which may or may not reduce the number of AWS KMS requests.<br>For more information, see: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html | `bool` | `false` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Bucket name. If provided, the bucket will be created with this name instead of generating the name from the context | `string` | n/a | yes |
| <a name="input_cors_configuration"></a> [cors\_configuration](#input\_cors\_configuration) | Specifies the allowed headers, methods, origins and exposed headers when using CORS on this bucket | <pre>list(object({<br>    id              = optional(string)<br>    allowed_headers = optional(list(string))<br>    allowed_methods = optional(list(string))<br>    allowed_origins = optional(list(string))<br>    expose_headers  = optional(list(string))<br>    max_age_seconds = optional(number)<br>  }))</pre> | `[]` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Enable S3 bucket notifications | `bool` | `false` | no |
| <a name="input_expected_bucket_owner"></a> [expected\_bucket\_owner](#input\_expected\_bucket\_owner) | The account ID of the expected bucket owner | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | When `true`, permits a non-empty S3 bucket to be deleted by first deleting all objects in the bucket.<br>THESE OBJECTS ARE NOT RECOVERABLE even if they were versioned and stored in Glacier. | `bool` | `false` | no |
| <a name="input_grants"></a> [grants](#input\_grants) | A list of policy grants for the bucket, taking a list of permissions.<br>Conflicts with `acl`. Set `acl` to `null` to use this.<br>Deprecated by AWS in favor of bucket policies.<br>Automatically disabled if `s3_object_ownership` is set to "BucketOwnerEnforced". | <pre>list(object({<br>    id          = string<br>    type        = string<br>    permissions = list(string)<br>    uri         = string<br>  }))</pre> | `[]` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Set to `false` to disable the ignoring of public access lists on the bucket | `bool` | `true` | no |
| <a name="input_kms_master_key_arn"></a> [kms\_master\_key\_arn](#input\_kms\_master\_key\_arn) | The AWS KMS master key ARN used for the `SSE-KMS` encryption. This can only be used when you set the value of `sse_algorithm` as `aws:kms`. The default aws/s3 AWS KMS master key is used if this element is absent while the `sse_algorithm` is `aws:kms` | `string` | `""` | no |
| <a name="input_lambda_function"></a> [lambda\_function](#input\_lambda\_function) | n/a | <pre>object({<br>    arn           = string<br>    filter_prefix = optional(string)<br>    filter_suffix = optional(string)<br>  })</pre> | <pre>{<br>  "arn": ""<br>}</pre> | no |
| <a name="input_lifecycle_rule"></a> [lifecycle\_rule](#input\_lifecycle\_rule) | List of maps containing configuration of object lifecycle management. | `any` | `[]` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | Bucket access logging configuration. Empty list for no logging, list of 1 to enable logging. | <pre>list(object({<br>    bucket_name = string<br>    prefix      = string<br>  }))</pre> | `[]` | no |
| <a name="input_notification_type"></a> [notification\_type](#input\_notification\_type) | Type of S3 bucket notification (lambda, queue, topic) | `string` | `"lambda"` | no |
| <a name="input_object_lock_configuration"></a> [object\_lock\_configuration](#input\_object\_lock\_configuration) | A configuration for S3 object locking. With S3 Object Lock, you can store objects using a `write once, read many` (WORM) model. Object Lock can help prevent objects from being deleted or overwritten for a fixed amount of time or indefinitely. | <pre>object({<br>    mode  = string # Valid values are GOVERNANCE and COMPLIANCE.<br>    days  = number<br>    years = number<br>  })</pre> | `null` | no |
| <a name="input_privileged_principal_actions"></a> [privileged\_principal\_actions](#input\_privileged\_principal\_actions) | List of actions to permit `privileged_principal_arns` to perform on bucket and bucket prefixes (see `privileged_principal_arns`) | `list(string)` | `[]` | no |
| <a name="input_privileged_principal_arns"></a> [privileged\_principal\_arns](#input\_privileged\_principal\_arns) | List of maps. Each map has a key, an IAM Principal ARN, whose associated value is<br>a list of S3 path prefixes to grant `privileged_principal_actions` permissions for that principal,<br>in addition to the bucket itself, which is automatically included. Prefixes should not begin with '/'. | `list(map(list(string)))` | `[]` | no |
| <a name="input_queue_arn"></a> [queue\_arn](#input\_queue\_arn) | arn for sqs queue for s3 event notifications | `string` | `null` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Set to `false` to disable the restricting of making the bucket public | `bool` | `true` | no |
| <a name="input_s3_object_ownership"></a> [s3\_object\_ownership](#input\_s3\_object\_ownership) | Specifies the S3 object ownership control.<br>Valid values are `ObjectWriter`, `BucketOwnerPreferred`, and 'BucketOwnerEnforced'.<br>Defaults to "ObjectWriter" for backwards compatibility, but we recommend setting "BucketOwnerEnforced" instead. | `string` | `"ObjectWriter"` | no |
| <a name="input_s3_replication_source_roles"></a> [s3\_replication\_source\_roles](#input\_s3\_replication\_source\_roles) | Cross-account IAM Role ARNs that will be allowed to perform S3 replication to this bucket (for replication within the same AWS account, it's not necessary to adjust the bucket policy). | `list(string)` | `[]` | no |
| <a name="input_source_ip_allow_list"></a> [source\_ip\_allow\_list](#input\_source\_ip\_allow\_list) | List of IP addresses to allow to perform all actions to the bucket | `list(string)` | `[]` | no |
| <a name="input_source_policy_documents"></a> [source\_policy\_documents](#input\_source\_policy\_documents) | List of IAM policy documents (in JSON) that are merged together into the exported document.<br>Statements defined in source\_policy\_documents must have unique SIDs.<br>Statement having SIDs that match policy SIDs generated by this module will override them. | `list(string)` | `[]` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms` | `string` | `"AES256"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign the resources. | `map(string)` | `{}` | no |
| <a name="input_topic_arn"></a> [topic\_arn](#input\_topic\_arn) | List of SNS topic ARN for notifications | `string` | `null` | no |
| <a name="input_transfer_acceleration_enabled"></a> [transfer\_acceleration\_enabled](#input\_transfer\_acceleration\_enabled) | Set this to `true` to enable S3 Transfer Acceleration for the bucket.<br>Note: When this is set to `false` Terraform does not perform drift detection<br>and will not disable Transfer Acceleration if it was enabled outside of Terraform.<br>To disable it via Terraform, you must set this to `true` and then to `false`.<br>Note: not all regions support Transfer Acceleration. | `bool` | `false` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket | `bool` | `true` | no |
| <a name="input_website_configuration"></a> [website\_configuration](#input\_website\_configuration) | Specifies the static website hosting configuration object | <pre>list(object({<br>    index_document = string<br>    error_document = string<br>    routing_rules = list(object({<br>      condition = object({<br>        http_error_code_returned_equals = string<br>        key_prefix_equals               = string<br>      })<br>      redirect = object({<br>        host_name               = string<br>        http_redirect_code      = string<br>        protocol                = string<br>        replace_key_prefix_with = string<br>        replace_key_with        = string<br>      })<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_website_redirect_all_requests_to"></a> [website\_redirect\_all\_requests\_to](#input\_website\_redirect\_all\_requests\_to) | If provided, all website requests will be redirected to the specified host name and protocol | <pre>list(object({<br>    host_name = string<br>    protocol  = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | Bucket ARN |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | Bucket Name (aka ID) |
| <a name="output_bucket_region"></a> [bucket\_region](#output\_bucket\_region) | Bucket region |
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
