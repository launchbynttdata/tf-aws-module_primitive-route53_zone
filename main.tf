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
  delegation_set_id = var.vpc_id == null ? var.delegation_set_id : null

  dynamic "vpc" {
    for_each = var.vpc_id != null ? [1] : []
    content {
      vpc_id     = var.vpc_id
      vpc_region = var.vpc_region
    }
  }

  lifecycle {
    precondition {
      condition     = var.vpc_id == null || var.delegation_set_id == null
      error_message = "vpc_id and delegation_set_id cannot both be set. Use vpc_id for private zones and delegation_set_id for public zones."
    }
  }
}
