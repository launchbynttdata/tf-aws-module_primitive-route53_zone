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

// Keep locals and validation in sync with the root module locals.tf and main.tf preconditions.
// No AWS provider: provider_default_region simulates data.aws_region.current.name.
// Scope: merge and region rules only. Root module vpc_block_for_each (legacy key "0" vs vpc_id keys)
// is not duplicated here; change both when that contract changes.

locals {
  all_vpc_associations = concat(
    var.vpc_id == null ? [] : [{ vpc_id = var.vpc_id, vpc_region = var.vpc_region }],
    var.vpc_associations,
  )

  associations_grouped = { for a in local.all_vpc_associations : a.vpc_id => a... }

  vpc_association_region_conflict = length(local.all_vpc_associations) > 0 && anytrue([
    for _, items in local.associations_grouped :
    length(distinct([
      for i in items : coalesce(try(i.vpc_region, null), var.provider_default_region)
    ])) > 1
  ])

  vpc_associations_by_id = {
    for vpc_id, items in local.associations_grouped :
    vpc_id => items[length(items) - 1]
  }
}

resource "terraform_data" "vpc_association_validation" {
  lifecycle {
    precondition {
      condition     = !local.vpc_association_region_conflict
      error_message = "Each vpc_id must map to a single effective vpc_region across vpc_id, vpc_region, and vpc_associations. Null vpc_region is treated as the configured AWS provider region (${var.provider_default_region})."
    }
  }
}
