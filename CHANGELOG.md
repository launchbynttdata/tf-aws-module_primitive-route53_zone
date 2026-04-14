# Changelog

## [Unreleased]

### Breaking Changes

- Widened AWS provider constraint from `~> 5.14` to `>= 5.0` (supports both v5 and v6+)
- Updated Terraform version constraint from `~> 1.5` to `~> 1.10`

### Added

- `primary_name_server` output exposing the Route 53 name server that created the SOA record
- `tags_all` output exposing all tags including those inherited from provider `default_tags`
- `examples/min_provider` example with `~> 5.0` constraint for minimum provider testing
- Terratest functions for minimum provider verification

### Validation

- Reviewed AWS provider v6 upgrade guide: no breaking changes to `aws_route53_zone`
- Reviewed `aws_route53_zone` resource documentation for provider v6
- Module validates with both AWS provider v5 and v6
- Updated example outputs to include `primary_name_server` and `tags_all`
