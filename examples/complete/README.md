# Route53 Zone Complete Example

This example creates an AWS Route53 hosted zone using the primitive module with resource naming.

## Usage

```hcl
data "aws_region" "current" {}

module "resource_names" {
  source   = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version  = "~> 2.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  class_env               = var.class_env
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  cloud_resource_type     = each.value.name
  maximum_length          = each.value.max_length

  region = join("", split("-", data.aws_region.current.name))
}

module "zone" {
  source = "../.."

  name = "${module.resource_names["route53_zone"].dns_compliant_minimal_random_suffix}.${var.base_domain}"

  comment            = var.comment
  tags               = var.tags
  vpc_id             = var.vpc_id
  vpc_region         = var.vpc_region
  delegation_set_id  = var.delegation_set_id
  force_destroy      = var.force_destroy
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_zone"></a> [zone](#module\_zone) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Name of the product family for which the resource is created. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Name of the product service for which the resource is created. | `string` | `"dns"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | Environment class (e.g., dev, prod). | `string` | `"dev"` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Instance environment number. | `string` | `"000"` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Instance resource identifier. | `string` | `"000"` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | Map of key to resource\_name for the resource\_name module. | <pre>map(object({<br/>    name       = string<br/>    max_length = optional(number, 60)<br/>  }))</pre> | <pre>{<br/>  "route53_zone": {<br/>    "max_length": 63,<br/>    "name": "r53"<br/>  }<br/>}</pre> | no |
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | Base domain for the hosted zone (e.g., launch.nttdata.com). Must be a domain you own. | `string` | n/a | yes |
| <a name="input_comment"></a> [comment](#input\_comment) | A comment for the hosted zone. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the hosted zone. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC to associate with a private hosted zone. Conflicts with delegation\_set\_id. | `string` | `null` | no |
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | The VPC's region. Defaults to the region of the AWS provider. | `string` | `null` | no |
| <a name="input_delegation_set_id"></a> [delegation\_set\_id](#input\_delegation\_set\_id) | The ID of the reusable delegation set. Conflicts with vpc\_id. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to destroy all records in the zone when destroying the zone. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the hosted zone (same as the zone\_id). |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The Hosted Zone ID. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | A list of name servers in the delegation set. |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the hosted zone. |
| <a name="output_name"></a> [name](#output\_name) | The name of the hosted zone. |
<!-- END_TF_DOCS -->
