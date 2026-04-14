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
// occurrence for the resolved map; conflicting vpc_region values for the same vpc_id fail the check below.

locals {
  all_vpc_associations = concat(
    var.vpc_id == null ? [] : [{ vpc_id = var.vpc_id, vpc_region = var.vpc_region }],
    var.vpc_associations,
  )

  associations_grouped = { for a in local.all_vpc_associations : a.vpc_id => a... }

  vpc_association_region_conflict = length(local.all_vpc_associations) > 0 && anytrue([
    for _, items in local.associations_grouped :
    length(distinct([for i in items : try(i.vpc_region, null)])) > 1
  ])

  # Last occurrence in concat order wins when the same vpc_id appears more than once.
  vpc_associations_by_id = {
    for vpc_id, items in local.associations_grouped :
    vpc_id => items[length(items) - 1]
  }
}

check "vpc_association_regions_consistent" {
  assert {
    condition     = !local.vpc_association_region_conflict
    error_message = "Each vpc_id must map to a single vpc_region across vpc_id, vpc_region, and vpc_associations (null counts as provider default region)."
  }
}
