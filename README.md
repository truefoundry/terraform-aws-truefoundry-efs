# terraform-aws-truefoundry-efs
Truefoundry AWS EFS Module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.57 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.57 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_efs"></a> [efs](#module\_efs) | cloudposse/efs/aws | 1.1.0 |
| <a name="module_iam_assumable_role_admin"></a> [iam\_assumable\_role\_admin](#module\_iam\_assumable\_role\_admin) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 5.27.0 |

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system_policy) | resource |
| [aws_iam_policy.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_document.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.efs_file_system_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | The oidc url of the eks cluster | `string` | n/a | yes |
| <a name="input_create_efs_iam_role"></a> [create\_efs\_iam\_role](#input\_create\_efs\_iam\_role) | Enable/disable creation of IAM role for EFS | `bool` | `true` | no |
| <a name="input_efs_node_iam_role_arn"></a> [efs\_node\_iam\_role\_arn](#input\_efs\_node\_iam\_role\_arn) | The node IAM role ARN being used by the EFS daemonset | `string` | n/a | yes |
| <a name="input_enable_backup_policy"></a> [enable\_backup\_policy](#input\_enable\_backup\_policy) | Enable EFS backup policy | `bool` | `true` | no |
| <a name="input_existing_efs_iam_role_arn"></a> [existing\_efs\_iam\_role\_arn](#input\_existing\_efs\_iam\_role\_arn) | ARN of the existing EFS IAM role. This will be used only when create\_efs\_iam\_role is set to false | `string` | `""` | no |
| <a name="input_k8s_service_account_name"></a> [k8s\_service\_account\_name](#input\_k8s\_service\_account\_name) | The k8s efs service account name | `string` | n/a | yes |
| <a name="input_k8s_service_account_namespace"></a> [k8s\_service\_account\_namespace](#input\_k8s\_service\_account\_namespace) | The k8s efs namespace | `string` | n/a | yes |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | the performance mode for EFS | `string` | n/a | yes |
| <a name="input_private_subnets_cidrs"></a> [private\_subnets\_cidrs](#input\_private\_subnets\_cidrs) | List of CIDR of private subnets | `list(string)` | n/a | yes |
| <a name="input_private_subnets_id"></a> [private\_subnets\_id](#input\_private\_subnets\_id) | List of private subnet IDs | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where the EFS will be provisioned | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS Tags common to all the resources created | `map(string)` | `{}` | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | the throughput mode for EFS | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the cluster and its nodes will be provisioned | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_arn"></a> [efs\_arn](#output\_efs\_arn) | n/a |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | n/a |
| <a name="output_efs_role_arn"></a> [efs\_role\_arn](#output\_efs\_role\_arn) | n/a |
| <a name="output_efs_security_group_id"></a> [efs\_security\_group\_id](#output\_efs\_security\_group\_id) | n/a |
<!-- END_TF_DOCS -->