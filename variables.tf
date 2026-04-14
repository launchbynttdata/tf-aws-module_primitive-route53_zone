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

variable "name" {
  description = "The name of the hosted zone (domain name)."
  type        = string
}

variable "comment" {
  description = "A comment for the hosted zone. Defaults to 'Managed by Terraform' when null."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the hosted zone."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "Single VPC to associate with a private hosted zone (legacy). Use vpc_associations for multiple VPCs. Combined with vpc_associations when both are set. Conflicts with delegation_set_id."
  type        = string
  default     = null
}

variable "vpc_region" {
  description = "Region for vpc_id when set. Defaults to the region of the AWS provider when null."
  type        = string
  default     = null
}

variable "vpc_associations" {
  description = "Additional VPC associations for a private hosted zone. Resolved map key is vpc_id (list order does not matter). Duplicate vpc_id entries must use the same vpc_region; the last entry wins. Conflicts with delegation_set_id."
  type = list(object({
    vpc_id     = string
    vpc_region = optional(string)
  }))
  default = []
}

variable "delegation_set_id" {
  description = "The ID of the reusable delegation set whose NS records you want to assign to the hosted zone. Conflicts with any private zone VPC association (vpc_id and/or vpc_associations)."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone."
  type        = bool
  default     = false
}
