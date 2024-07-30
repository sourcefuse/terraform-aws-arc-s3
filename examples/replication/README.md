# terraform-aws-arc-s3

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0, < 6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dest_bucket"></a> [dest\_bucket](#module\_dest\_bucket) | ../../ | n/a |
| <a name="module_replication"></a> [replication](#module\_replication) | ../../ | n/a |
| <a name="module_src_bucket"></a> [src\_bucket](#module\_src\_bucket) | ../../ | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | ACL value | `string` | n/a | yes |
| <a name="input_dest_bucket_name"></a> [dest\_bucket\_name](#input\_dest\_bucket\_name) | Destination Bucket Name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_src_bucket_name"></a> [src\_bucket\_name](#input\_src\_bucket\_name) | Source Bucket Name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dest_bucket_arn"></a> [dest\_bucket\_arn](#output\_dest\_bucket\_arn) | n/a |
| <a name="output_dest_bucket_id"></a> [dest\_bucket\_id](#output\_dest\_bucket\_id) | n/a |
| <a name="output_destination_buckets"></a> [destination\_buckets](#output\_destination\_buckets) | n/a |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | Role used to S3 replication |
| <a name="output_src_bucket_arn"></a> [src\_bucket\_arn](#output\_src\_bucket\_arn) | n/a |
| <a name="output_src_bucket_id"></a> [src\_bucket\_id](#output\_src\_bucket\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
