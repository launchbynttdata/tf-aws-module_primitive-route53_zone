# AWS Route53 Zone Primitive Module

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This Terraform module creates an AWS Route53 hosted zone. It wraps the `aws_route53_zone` resource and supports both public and private hosted zones.

### Upgrade impact: private zone VPC nested blocks

Older releases used a `dynamic "vpc"` block with a **placeholder instance key** (`"0"`) when only **`vpc_id`** was set. This module keeps that address when **`vpc_id` is set and `vpc_associations` is empty**, so upgrades for that common case should **not** show nested `vpc` destroy/create churn from Terraform addressing alone.

When **`vpc_associations` is non-empty**, nested blocks use **`for_each` keys equal to `vpc_id`** (merged with legacy `vpc_id` / `vpc_region` when both are set). If you previously had only **`vpc_id`** in state under `vpc["0"]` and you start passing **`vpc_associations`**, expect a **one-time** nested address change (`"0"` to your VPC ID string). Review `terraform plan` carefully. You can use a **`moved` block** in the **root** configuration with **literal** addresses (for example from `module.zone.aws_route53_zone.zone.vpc["0"]` to `module.zone.aws_route53_zone.zone.vpc["vpc-0123456789abcdef0"]`) if your module label and VPC ID are fixed for that workspace.

**Validation:** conflicting `vpc_region` values for the same `vpc_id` are rejected by **`lifecycle` preconditions** on `aws_route53_zone.zone` (plan fails; not a `check` block). **Public zones** (no VPC arguments) are unaffected.

## Usage

```hcl
module "zone" {
  source = "terraform.registry.launch.nttdata.com/module_primitive/route53_zone/aws"
  version = "~> 1.0"

  name   = "example.com"
  tags   = var.tags
}
```

See the [complete example](examples/complete/) for a full working example with resource naming.

## Prerequisites

- [asdf](https://github.com/asdf-vm/asdf) or [mise](https://mise.jdx.dev/) for tool version management
- [make](https://www.gnu.org/software/make/)
- [repo](https://android.googlesource.com/tools/repo) for pulling components

### Repo Init

```shell
make configure
```

### Local Testing

1. Set AWS credentials (e.g., `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION` or use a profile).
2. For the example, ensure `base_domain` in `examples/complete/test.tfvars` is a domain you own.
3. Run validation (includes `terraform-test` for the VPC merge harness, then platform `lint` / `test` from `components/` when that tree is present after `make configure`):

```shell
make check
```

To run only the locals-only harness (`terraform test` under `tests/unit/vpc_associations_merge/`, no AWS provider):

```shell
make terraform-test
```

## Pre-Commit Hooks

The [.pre-commit-config.yaml](.pre-commit-config.yaml) defines hooks for Terraform, Go, and linting. The `commitlint` hook enforces conventional commit messages.

The `detect-secrets-hook` prevents new secrets from being introduced. See [pre-commit hooks documentation](https://pre-commit.com/) for details.

To install the commit message hook:

```shell
pre-commit install --hook-type commit-msg
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.39.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the hosted zone (domain name). | `string` | n/a | yes |
| <a name="input_comment"></a> [comment](#input\_comment) | A comment for the hosted zone. Defaults to 'Managed by Terraform' when null. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the hosted zone. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Single VPC to associate with a private hosted zone (legacy). Use vpc\_associations for multiple VPCs. Combined with vpc\_associations when both are set. Conflicts with delegation\_set\_id. | `string` | `null` | no |
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | Region for vpc\_id when set. Defaults to the region of the AWS provider when null. | `string` | `null` | no |
| <a name="input_vpc_associations"></a> [vpc\_associations](#input\_vpc\_associations) | VPC associations for a private hosted zone. When vpc\_id is also set, entries are merged after the legacy vpc\_id (same vpc\_id: last occurrence wins). Resolved map key is vpc\_id (list order does not matter). Duplicate vpc\_id entries must use the same vpc\_region; the last entry wins. Conflicts with delegation\_set\_id. | <pre>list(object({<br/>    vpc_id     = string<br/>    vpc_region = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_delegation_set_id"></a> [delegation\_set\_id](#input\_delegation\_set\_id) | The ID of the reusable delegation set whose NS records you want to assign to the hosted zone. Conflicts with any private zone VPC association (vpc\_id and/or vpc\_associations). | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the resource (same as the zone\_id). |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The Hosted Zone ID. This can be referenced by zone records. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | A list of name servers in the associated (or default) delegation set. |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the hosted zone. |
| <a name="output_name"></a> [name](#output\_name) | The name of the hosted zone. |
| <a name="output_primary_name_server"></a> [primary\_name\_server](#output\_primary\_name\_server) | The Route 53 name server that created the SOA record. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
<!-- END_TF_DOCS -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.39.0 |

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
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | Base domain for the hosted zone (e.g., launch.nttdata.com). Must be a domain you own. | `string` | n/a | yes |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | Environment class (e.g., dev, prod). | `string` | `"dev"` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | A comment for the hosted zone. | `string` | `null` | no |
| <a name="input_delegation_set_id"></a> [delegation\_set\_id](#input\_delegation\_set\_id) | The ID of the reusable delegation set. Conflicts with vpc\_id and vpc\_associations. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to destroy all records in the zone when destroying the zone. | `bool` | `false` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Instance environment number. | `string` | `"000"` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Instance resource identifier. | `string` | `"000"` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Name of the product family for which the resource is created. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Name of the product service for which the resource is created. | `string` | `"dns"` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | Map of key to resource\_name for the resource\_name module. | <pre>map(object({<br/>    name       = string<br/>    max_length = optional(number, 60)<br/>  }))</pre> | <pre>{<br/>  "route53_zone": {<br/>    "max_length": 63,<br/>    "name": "r53"<br/>  }<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the hosted zone. | `map(string)` | `{}` | no |
| <a name="input_vpc_associations"></a> [vpc\_associations](#input\_vpc\_associations) | VPC associations for a private hosted zone (order-independent). Conflicts with delegation\_set\_id. | <pre>list(object({<br/>    vpc_id     = string<br/>    vpc_region = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Single VPC for a private hosted zone (legacy). Conflicts with delegation\_set\_id. | `string` | `null` | no |
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | Region for vpc\_id when set. Defaults to the region of the AWS provider when null. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the hosted zone. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the hosted zone (same as the zone\_id). |
| <a name="output_name"></a> [name](#output\_name) | The name of the hosted zone. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | A list of name servers in the delegation set. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The Hosted Zone ID. |
<!-- END_TF_DOCS -->
