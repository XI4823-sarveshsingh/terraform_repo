# Terraform Script to create S3 bucket with VPC Endpoint

## Resources Created

* S3 bucket 
* S3 with VPC endpoint  
* ACL, Tags and s3 bucket configuration
* aws_s3_bucket_metric


## Best Practices

* S3 with VPC endpoint
* S3 versioning
* Lifecycle rules
* Server-side encryption	
* S3 access logging
* object locking


## Module reference

https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/tree/v2.6.0

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_region_name"></a> [region\_name](#input\region\_name) | Region name | `string` | `[]`
| <a name="input_bucket_Name"></a> [bucket\_name](#input\_bucket\_name) | The name of the bucket. and name should be unique name. | `string` | `[]` |
| <a name="input_force_destroy"></a> [force\_destroy](#force\_destroy) | Forcefully delete the bucket which had a objects | `bool` | `true` 
| <a name="input_attach_policy"></a> [attach\_policy](#input\attach\_policy) | Controls if S3 bucket should have bucket policy attached -true/false | `bool` | `[]`
| <a name="input_deny_insecure"></a> [deny\_insecure](#deny\_insecure) | Attach_deny_insecure_transport_policy | `bool` | `true`
| <a name="input_versioning"></a> [versioning](#versioning) | versioning on S3 bucket | `bool` | `true` 
| <a name="input_project"></a> [project](#input\_project) | Name of the project for which s3 bucket is provisioned (needed for tagging) | `string` | `[]`
| <a name="input_environment_class"></a> [environment_class](#input\_environment_class) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `[]`
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#kms\_key\_arn) | Enter amazone KMS key arn | `string` | `[]`
| <a name="input_object_lock"></a> [object\_lock](#input\_object\_lock) | If you want to 'enabled' object lock default its 'Disabled'| `string` | `[]`
| <a name="input_lifecycle_rule_enabled"></a> [lifecycle\_rule\_enabled](#lifecycle\_rule\_enabled) | Enter lifecycle_rule prefix | `bool` | `false`
| <a name="input_lifecycle_rule_prefix"></a> [lifecycle\_rule\_prefix](#lifecycle\_rule\_prefix) | Enter lifecycle_rule prefix | `string` | `log`
| <a name="input_current_transition"></a> [current\_transition](#current\_transition) | provide current_transition components(Days and storage_class) | `any` | ``
| <a name="input_expiration_days"></a> [expiration\_days](#expiration\_days) | Enter the expiration_days | `number` | `30`
| <a name="input_noncurrent_version_expiration_days"></a> [noncurrent\_version\_expiration\_days](#noncurrent\_version\_expiration\_days) | Enter the noncurrent_version_expiration_days | `number` | `300`
| <a name="input_abort_incomplete_multipart_upload_days"></a> [abort\_incomplete\_multipart\_upload\_days](#abort\_incomplete\_multipart\_upload\_days) | Number of days to abort_incomplete_multipart_upload_days | `number` | `7`
| <a name="input_noncurrent_version_transition"></a> [noncurrent\_version\_transition](#noncurrent\_version\_transition) | provide noncurrent_version_transition components(Days and storage_class) | `any` | ``
| <a name="input_block_public_acls"></a> [block\_public\_acls](#block\_public\_acls) |If you dont want to block_public_acls set 'false' but it should be 'true'| `bool` | `true`
| <a name="input_block_public_policy"></a> [block\_public\_policy](#block\_public\_policy) | If you dont want to block_public_policy set 'false' but it should be 'true' | `bool` | `true`
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#ignore\_public\_acls) | If you dont want to ignore_public_acls set 'false' but it should be 'true' | `bool` | `true`
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#restrict\_public\_buckets) | If you dont want to restrict_public_buckets set 'false' but it should be 'true' | `bool` | `true`
| <a name="input_vpc_id"></a> [vpc\_id](#input\vpc\_id) | vpc id to configure endpoint | `string` | `[]`
| <a name="input_vpc_endpoint_name"></a> [vpc\_endpoint\_name](#input\_vpc\_endpoint\_name) | Name of the VPC endpoint (needed for tagging) | `string` | `[]`
| <a name="input_route_table_id"></a> [route\_table\_id](#input\route\_table\_id) | route table id to configure to associate with endpoint | `string` | `[]`



## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_arn"></a> [s3_bucket\_arn](#output\s3_bucket\_arn) | Amazon Resource Name (ARN) of the s3 bucket |
| <a name="output_vpc_endpoint_arn"></a> [vpc_endpoint\_arn](#output\vpc_endpoint\_arn) | Amazon Resource Name (ARN) of the vpc endpoint |
| <a name="output_33_bucket_id"></a> [s3_bucket\_id](#output\s3_bucket\_id) | Amazon s3 bucket id|
| <a name="output_s3_bucket_bucket_domain_name"></a> [s3_bucket\_bucket\_domain\_name](#output\bucket_domain\_Name) |Amazon s3_bucket_bucket_domain_name|



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.replication-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_accelerate_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_intelligent_tiering_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_intelligent_tiering_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_metric.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric) | resource |
| [aws_s3_bucket_object_lock_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.replication-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.log_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.replication-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.log_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.deny_insecure_transport](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.policy_document](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | Sets the access control list for the bucket. Can be private or public-read. | `string` | `"private"` | no |
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | Assume role in which account to create | `string` | `""` | no |
| <a name="input_attach_deny_insecure_transport_policy"></a> [attach\_deny\_insecure\_transport\_policy](#input\_attach\_deny\_insecure\_transport\_policy) | Controls if S3 bucket should have deny non-SSL transport policy attached | `bool` | `false` | no |
| <a name="input_attach_policy"></a> [attach\_policy](#input\_attach\_policy) | Controls if S3 bucket should have bucket policy attached (set to `true` to use value of `policy` as bucket policy) | `bool` | `false` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Add common tags to your resource | `map(string)` | `{}` | no |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | List of maps containing rules for Cross-Origin Resource Sharing. | `list(any)` | `[]` | no |
| <a name="input_enable_acceleration_status"></a> [enable\_acceleration\_status](#input\_enable\_acceleration\_status) | Sets the accelerate configuration of an existing bucket. | `bool` | `true` | no |
| <a name="input_enable_cors_config"></a> [enable\_cors\_config](#input\_enable\_cors\_config) | Whether cors configuration should be enabled or not on s3 bucket. | `bool` | `true` | no |
| <a name="input_enable_force_destroy"></a> [enable\_force\_destroy](#input\_enable\_force\_destroy) | A boolean that indicates all objects should be deleted from the bucket when the bucket is destroyed | `bool` | `false` | no |
| <a name="input_enable_intelligent_tiering"></a> [enable\_intelligent\_tiering](#input\_enable\_intelligent\_tiering) | Whether to enable intelligent tiering or not | `bool` | `false` | no |
| <a name="input_enable_lifecycle_configuration"></a> [enable\_lifecycle\_configuration](#input\_enable\_lifecycle\_configuration) | Whether to enable lifecycle configuration or not | `bool` | `false` | no |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | Whether to enable logging bucket or not | `bool` | `true` | no |
| <a name="input_enable_object_lock"></a> [enable\_object\_lock](#input\_enable\_object\_lock) | Whether S3 bucket should have an Object Lock configuration enabled | `bool` | `true` | no |
| <a name="input_enable_replication"></a> [enable\_replication](#input\_enable\_replication) | Whether to enable replication bucket or not | `bool` | `true` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket | `bool` | `true` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_intelligent_tiering"></a> [intelligent\_tiering](#input\_intelligent\_tiering) | Map containing intelligent tiering configuration. | `map(any)` | `{}` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Contain key id for kms key | `string` | n/a | yes |
| <a name="input_lifecycle_rule"></a> [lifecycle\_rule](#input\_lifecycle\_rule) | List of maps containing configuration of object lifecycle management. | `list(any)` | `[]` | no |
| <a name="input_metric_configuration"></a> [metric\_configuration](#input\_metric\_configuration) | Map containing bucket metric configuration. | `list(any)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Provide a name for the bucket to be created | `string` | n/a | yes |
| <a name="input_object_lock_configuration"></a> [object\_lock\_configuration](#input\_object\_lock\_configuration) | Map containing S3 object locking configuration. | `map(any)` | `{}` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL. | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_policy_path"></a> [policy\_path](#input\_policy\_path) | The path of the policy document to be used to create policy | `string` | `""` | no |
| <a name="input_policy_vars"></a> [policy\_vars](#input\_policy\_vars) | Policy variables to substitue in policy document(if any) | `map(any)` | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | Provide region name | `string` | `"ap-south-1"` | no |
| <a name="input_replication_configuration"></a> [replication\_configuration](#input\_replication\_configuration) | Specifies the replication rules for S3 bucket replication if enabled | `map(any)` | `{}` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_website"></a> [website](#input\_website) | Map containing static web-site hosting or redirect configuration. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the bucket. |
| <a name="output_s3_bucket_region"></a> [s3\_bucket\_region](#output\_s3\_bucket\_region) | The AWS region this bucket resides in. |
| <a name="output_s3_bucket_website_domain"></a> [s3\_bucket\_website\_domain](#output\_s3\_bucket\_website\_domain) | The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. |
| <a name="output_s3_bucket_website_endpoint"></a> [s3\_bucket\_website\_endpoint](#output\_s3\_bucket\_website\_endpoint) | The website endpoint, if the bucket is configured with a website. If not, this will be an empty string. |
<!-- END_TF_DOCS -->