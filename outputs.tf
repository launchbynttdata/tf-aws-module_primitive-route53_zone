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

output "id" {
  description = "The ID of the resource (same as the zone_id)."
  value       = aws_route53_zone.zone.id
}

output "zone_id" {
  description = "The Hosted Zone ID. This can be referenced by zone records."
  value       = aws_route53_zone.zone.zone_id
}

output "name_servers" {
  description = "A list of name servers in the associated (or default) delegation set."
  value       = aws_route53_zone.zone.name_servers
}

output "arn" {
  description = "The ARN of the hosted zone."
  value       = aws_route53_zone.zone.arn
}

output "name" {
  description = "The name of the hosted zone."
  value       = aws_route53_zone.zone.name
}

output "primary_name_server" {
  description = "The Route 53 name server that created the SOA record."
  value       = aws_route53_zone.zone.primary_name_server
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_route53_zone.zone.tags_all
}
