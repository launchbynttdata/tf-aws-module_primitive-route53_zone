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

output "sorted_association_vpc_ids" {
  value = sort(keys(local.vpc_associations_by_id))
}

output "associations_canonical_json" {
  value = jsonencode({
    for k in sort(keys(local.vpc_associations_by_id)) : k => {
      vpc_id     = local.vpc_associations_by_id[k].vpc_id
      vpc_region = try(local.vpc_associations_by_id[k].vpc_region, null)
    }
  })
}
