# vpc_associations_merge

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [terraform_data.vpc_association_validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `null` | no |
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | n/a | `string` | `null` | no |
| <a name="input_vpc_associations"></a> [vpc\_associations](#input\_vpc\_associations) | n/a | <pre>list(object({<br/>    vpc_id     = string<br/>    vpc_region = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_provider_default_region"></a> [provider\_default\_region](#input\_provider\_default\_region) | Region used when coalescing null vpc\_region in this harness (mirrors data.aws\_region.current.name in the root module). | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sorted_association_vpc_ids"></a> [sorted\_association\_vpc\_ids](#output\_sorted\_association\_vpc\_ids) | n/a |
| <a name="output_associations_canonical_json"></a> [associations\_canonical\_json](#output\_associations\_canonical\_json) | n/a |
<!-- END_TF_DOCS -->
