// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Merge order: legacy vpc_id first, then vpc_associations. Duplicate vpc_id uses the last
// occurrence for the resolved map; conflicting effective vpc_region values for the same vpc_id
// fail the lifecycle precondition on aws_route53_zone.zone (null vpc_region counts as data.aws_region.current.name).

locals {
  all_vpc_associations = concat(
    var.vpc_id == null ? [] : [{ vpc_id = var.vpc_id, vpc_region = var.vpc_region }],
    var.vpc_associations,
  )

  associations_grouped = { for a in local.all_vpc_associations : a.vpc_id => a... }

  vpc_association_region_conflict = length(local.all_vpc_associations) > 0 && anytrue([
    for _, items in local.associations_grouped :
    length(distinct([
      for i in items : coalesce(try(i.vpc_region, null), data.aws_region.current.name)
    ])) > 1
  ])

  # Last occurrence in concat order wins when the same vpc_id appears more than once.
  vpc_associations_by_id = {
    for vpc_id, items in local.associations_grouped :
    vpc_id => items[length(items) - 1]
  }

  # Legacy-only private zone: keep nested dynamic "vpc" instance key "0" to match older
  # releases (for_each was a single-element list). Otherwise key by vpc_id for stable addresses.
  legacy_single_vpc_association_only = var.vpc_id != null && length(var.vpc_associations) == 0

  vpc_block_for_each = local.legacy_single_vpc_association_only ? {
    "0" = {
      vpc_id     = var.vpc_id
      vpc_region = var.vpc_region
    }
  } : local.vpc_associations_by_id
}
