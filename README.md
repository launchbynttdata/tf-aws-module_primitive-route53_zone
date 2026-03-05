# AWS Route53 Zone Primitive Module

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This Terraform module creates an AWS Route53 hosted zone. It wraps the `aws_route53_zone` resource and supports both public and private hosted zones.

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
3. Run:

```shell
make check
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the hosted zone (domain name). | `string` | n/a | yes |
| <a name="input_comment"></a> [comment](#input\_comment) | A comment for the hosted zone. Defaults to 'Managed by Terraform' when null. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the hosted zone. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC to associate with a private hosted zone. Specifying this creates a private hosted zone. Conflicts with delegation\_set\_id. | `string` | `null` | no |
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | The VPC's region. Defaults to the region of the AWS provider. | `string` | `null` | no |
| <a name="input_delegation_set_id"></a> [delegation\_set\_id](#input\_delegation\_set\_id) | The ID of the reusable delegation set whose NS records you want to assign to the hosted zone. Conflicts with vpc\_id as delegation sets can only be used for public zones. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the resource (same as the zone\_id). |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The Hosted Zone ID. This can be referenced by zone records. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | A list of name servers in the associated (or default) delegation set. |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the hosted zone. |
| <a name="output_name"></a> [name](#output\_name) | The name of the hosted zone. |
<!-- END_TF_DOCS -->

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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_comment"></a> [comment](#input\_comment) | A comment for the hosted zone. Defaults to 'Managed by Terraform' when null. | `string` | `null` | no |
| <a name="input_delegation_set_id"></a> [delegation\_set\_id](#input\_delegation\_set\_id) | The ID of the reusable delegation set whose NS records you want to assign to the hosted zone. Conflicts with vpc\_id as delegation sets can only be used for public zones. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the hosted zone (domain name). | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the hosted zone. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC to associate with a private hosted zone. Specifying this creates a private hosted zone. Conflicts with delegation\_set\_id. | `string` | `null` | no |
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | The VPC's region. Defaults to the region of the AWS provider. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the hosted zone. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the resource (same as the zone\_id). |
| <a name="output_name"></a> [name](#output\_name) | The name of the hosted zone. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | A list of name servers in the associated (or default) delegation set. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The Hosted Zone ID. This can be referenced by zone records. |
<!-- END_TF_DOCS -->
