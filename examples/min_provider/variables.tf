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

variable "logical_product_family" {
  description = "Name of the product family for which the resource is created."
  type        = string
  default     = "launch"
}

variable "logical_product_service" {
  description = "Name of the product service for which the resource is created."
  type        = string
  default     = "dns"
}

variable "class_env" {
  description = "Environment class (e.g., dev, prod)."
  type        = string
  default     = "dev"
}

variable "instance_env" {
  description = "Instance environment number."
  type        = string
  default     = "000"
}

variable "instance_resource" {
  description = "Instance resource identifier."
  type        = string
  default     = "000"
}

variable "resource_names_map" {
  description = "Map of key to resource_name for the resource_name module."
  type = map(object({
    name       = string
    max_length = optional(number, 60)
  }))
  default = {
    route53_zone = {
      name       = "r53"
      max_length = 63
    }
  }
}

variable "base_domain" {
  description = "Base domain for the hosted zone (e.g., launch.nttdata.com). Must be a domain you own."
  type        = string
}

variable "comment" {
  description = "A comment for the hosted zone."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the hosted zone."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The VPC to associate with a private hosted zone. Conflicts with delegation_set_id."
  type        = string
  default     = null
}

variable "vpc_region" {
  description = "The VPC's region. Defaults to the region of the AWS provider."
  type        = string
  default     = null
}

variable "delegation_set_id" {
  description = "The ID of the reusable delegation set. Conflicts with vpc_id."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Whether to destroy all records in the zone when destroying the zone."
  type        = bool
  default     = false
}
