# Changelog

## [Unreleased]

### Breaking Changes

- Upgraded AWS provider from `~> 5.14` to `~> 6.0`
- Updated Terraform version constraint from `~> 1.5` to `~> 1.10`

### Added

- `enable_accelerated_recovery` variable to enable accelerated recovery for hosted zones
- `primary_name_server` output exposing the Route 53 name server that created the SOA record
- `tags_all` output exposing all tags including those inherited from provider `default_tags`

### Validation

- Reviewed AWS provider v6 upgrade guide: no breaking changes to `aws_route53_zone`
- Reviewed `aws_route53_zone` resource documentation for provider v6
- Updated module implementation for compatibility with AWS provider v6
- Updated examples to exercise new `enable_accelerated_recovery` variable
- Updated example outputs to include `primary_name_server` and `tags_all`
