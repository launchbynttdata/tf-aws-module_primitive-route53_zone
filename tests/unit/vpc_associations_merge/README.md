# vpc_associations_merge

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `null` | no |
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | n/a | `string` | `null` | no |
| <a name="input_vpc_associations"></a> [vpc\_associations](#input\_vpc\_associations) | n/a | <pre>list(object({<br/>    vpc_id     = string<br/>    vpc_region = optional(string)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sorted_association_vpc_ids"></a> [sorted\_association\_vpc\_ids](#output\_sorted\_association\_vpc\_ids) | n/a |
| <a name="output_associations_canonical_json"></a> [associations\_canonical\_json](#output\_associations\_canonical\_json) | n/a |
<!-- END_TF_DOCS -->
