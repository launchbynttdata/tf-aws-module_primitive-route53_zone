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

resource "aws_route53_zone" "zone" {
  name = var.name

  comment           = var.comment
  tags              = var.tags
  force_destroy     = var.force_destroy
  delegation_set_id = length(local.vpc_associations_by_id) == 0 ? var.delegation_set_id : null

  dynamic "vpc" {
    for_each = local.vpc_associations_by_id
    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = vpc.value.vpc_region
    }
  }

  lifecycle {
    precondition {
      condition     = length(local.vpc_associations_by_id) == 0 || var.delegation_set_id == null
      error_message = "Private zone VPC associations (vpc_id and/or vpc_associations) cannot be combined with delegation_set_id. Use VPC associations for private zones and delegation_set_id for public zones."
    }
  }
}
