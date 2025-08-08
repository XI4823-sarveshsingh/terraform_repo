# terraform-aws-xebia-ecr
Terraform module to deploy ECR repo

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_template"></a> [template](#provider\_template) | ~> 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_pull_through_cache_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_pull_through_cache_rule) | resource |
| [aws_ecr_registry_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_policy) | resource |
| [aws_ecr_registry_scanning_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_registry_scanning_configuration) | resource |
| [aws_ecr_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_replication_configuration) | resource |
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_ecrpublic_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecrpublic_repository) | resource |
| [aws_ecrpublic_repository_policy.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecrpublic_repository_policy) | resource |
| [template_file.policy_document](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.registry_policy_document](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | Assume role in which account to create | `string` | `""` | no |
| <a name="input_catalog_data"></a> [catalog\_data](#input\_catalog\_data) | Catalog data configuration for the repository | `any` | `{}` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Add common tags to your resources | `map(string)` | `{}` | no |
| <a name="input_create_registry_replication_configuration"></a> [create\_registry\_replication\_configuration](#input\_create\_registry\_replication\_configuration) | Determines whether a registry replication configuration will be created | `bool` | `false` | no |
| <a name="input_enable_force_delete"></a> [enable\_force\_delete](#input\_enable\_force\_delete) | Whether to delete the repository even if it contains images | `bool` | `false` | no |
| <a name="input_enable_image_scan_on_push"></a> [enable\_image\_scan\_on\_push](#input\_enable\_image\_scan\_on\_push) | Indicates whether images are scanned after being pushed to the repository (`true`) or not scanned (`false`) | `bool` | `true` | no |
| <a name="input_encryption_type"></a> [encryption\_type](#input\_encryption\_type) | The encryption type for the repository. Must be one of: `KMS` or `AES256`. Defaults to `KMS` | `string` | `"KMS"` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`. Defaults to `IMMUTABLE` | `string` | `"IMMUTABLE"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN of the KMS key to use when encryption\_type is `KMS`. If not specified, uses the default AWS managed key for ECR | `string` | `""` | no |
| <a name="input_lifecycle_policy_path"></a> [lifecycle\_policy\_path](#input\_lifecycle\_policy\_path) | The path of the lifecycle policy document. Empty value indicates no lifecycle policy will be created | `string` | `""` | no |
| <a name="input_manage_registry_scanning_config"></a> [manage\_registry\_scanning\_config](#input\_manage\_registry\_scanning\_config) | Determines whether the registry scanning configuration will be managed | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the repository | `string` | n/a | yes |
| <a name="input_permissions_policy_path"></a> [permissions\_policy\_path](#input\_permissions\_policy\_path) | The path of the permissions policy document to be used to create permissions policy. Empty value indicates no permissions policy will be created | `string` | `""` | no |
| <a name="input_permissions_policy_vars"></a> [permissions\_policy\_vars](#input\_permissions\_policy\_vars) | Map of policy variables to substitue in permissions policy document(if any) | `map(any)` | `{}` | no |
| <a name="input_pull_through_cache_rules"></a> [pull\_through\_cache\_rules](#input\_pull\_through\_cache\_rules) | List of pull through cache rules to create | `list(any)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | Region in which Redis needs to create. | `string` | `"ap-south-1"` | no |
| <a name="input_registry_policy_path"></a> [registry\_policy\_path](#input\_registry\_policy\_path) | Path of the registry policy document. Empty value indicates no registry policy will be created | `string` | `""` | no |
| <a name="input_registry_policy_vars"></a> [registry\_policy\_vars](#input\_registry\_policy\_vars) | Map of registry policy variables to substitue in registroy policy document(if any) | `map(any)` | `{}` | no |
| <a name="input_registry_replication_rules"></a> [registry\_replication\_rules](#input\_registry\_replication\_rules) | The replication rules for a replication configuration. A maximum of 10 are allowed | `list(any)` | `[]` | no |
| <a name="input_registry_scan_rules"></a> [registry\_scan\_rules](#input\_registry\_scan\_rules) | One or multiple blocks specifying scanning rules to determine which repository filters are used and at what frequency scanning will occur | `list(any)` | `[]` | no |
| <a name="input_registry_scan_type"></a> [registry\_scan\_type](#input\_registry\_scan\_type) | the scanning type to set for the registry. Can be either `ENHANCED` or `BASIC` | `string` | `"ENHANCED"` | no |
| <a name="input_type"></a> [type](#input\_type) | The type of repository to create. Either `public` or `private`. Public repo can only be used with 'region' variable set to us-east-1 | `string` | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_arn"></a> [repository\_arn](#output\_repository\_arn) | Full ARN of the repository |
| <a name="output_repository_registry_id"></a> [repository\_registry\_id](#output\_repository\_registry\_id) | The registry ID where the repository was created |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | The URL of the repository |
<!-- END_TF_DOCS -->