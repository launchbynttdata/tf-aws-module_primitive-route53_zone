# vpc_associations_merge

Provider-free `terraform test` harness. It asserts **`vpc_associations_by_id` merge order**, duplicate `vpc_id` resolution, and **region conflict** rules (mirroring [`locals.tf`](../../locals.tf) and the root module preconditions). It does **not** exercise the Route53 resource: the **`dynamic "vpc"` `for_each` instance key** strategy (`vpc["0"]` when legacy-only vs keys by `vpc_id` when `vpc_associations` is non-empty) lives in the root [`locals.tf`](../../locals.tf) and [`main.tf`](../../main.tf). When changing either behavior, update this directory in the same change.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [terraform_data.vpc_association_validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_provider_default_region"></a> [provider\_default\_region](#input\_provider\_default\_region) | Region used when coalescing null vpc\_region in this harness (mirrors data.aws\_region.current.name in the root module). | `string` | `"us-east-1"` | no |
| <a name="input_vpc_associations"></a> [vpc\_associations](#input\_vpc\_associations) | n/a | <pre>list(object({<br/>    vpc_id     = string<br/>    vpc_region = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `null` | no |
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_associations_canonical_json"></a> [associations\_canonical\_json](#output\_associations\_canonical\_json) | n/a |
| <a name="output_sorted_association_vpc_ids"></a> [sorted\_association\_vpc\_ids](#output\_sorted\_association\_vpc\_ids) | n/a |
<!-- END_TF_DOCS -->
