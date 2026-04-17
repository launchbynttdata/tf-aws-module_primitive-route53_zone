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

run "reorder_list_ab" {
  command = plan

  variables {
    vpc_associations = [
      { vpc_id = "vpc-aaaaaaaaaaaaaaaa", vpc_region = "us-east-1" },
      { vpc_id = "vpc-bbbbbbbbbbbbbbbb", vpc_region = "us-west-2" },
    ]
  }

  assert {
    condition     = output.sorted_association_vpc_ids == tolist(["vpc-aaaaaaaaaaaaaaaa", "vpc-bbbbbbbbbbbbbbbb"])
    error_message = "reorder_list_ab: sorted vpc ids mismatch"
  }

  assert {
    condition     = output.associations_canonical_json == "{\"vpc-aaaaaaaaaaaaaaaa\":{\"vpc_id\":\"vpc-aaaaaaaaaaaaaaaa\",\"vpc_region\":\"us-east-1\"},\"vpc-bbbbbbbbbbbbbbbb\":{\"vpc_id\":\"vpc-bbbbbbbbbbbbbbbb\",\"vpc_region\":\"us-west-2\"}}"
    error_message = "reorder_list_ab: canonical json mismatch"
  }
}

run "reorder_list_ba" {
  command = plan

  variables {
    vpc_associations = [
      { vpc_id = "vpc-bbbbbbbbbbbbbbbb", vpc_region = "us-west-2" },
      { vpc_id = "vpc-aaaaaaaaaaaaaaaa", vpc_region = "us-east-1" },
    ]
  }

  assert {
    condition     = output.associations_canonical_json == "{\"vpc-aaaaaaaaaaaaaaaa\":{\"vpc_id\":\"vpc-aaaaaaaaaaaaaaaa\",\"vpc_region\":\"us-east-1\"},\"vpc-bbbbbbbbbbbbbbbb\":{\"vpc_id\":\"vpc-bbbbbbbbbbbbbbbb\",\"vpc_region\":\"us-west-2\"}}"
    error_message = "reorder_list_ba: canonical json mismatch"
  }
}

run "legacy_plus_associations" {
  command = plan

  variables {
    vpc_id     = "vpc-cccccccccccccccc"
    vpc_region = "eu-west-1"
    vpc_associations = [
      { vpc_id = "vpc-dddddddddddddddd", vpc_region = null },
    ]
  }

  assert {
    condition     = output.sorted_association_vpc_ids == tolist(["vpc-cccccccccccccccc", "vpc-dddddddddddddddd"])
    error_message = "legacy_plus_associations: sorted vpc ids mismatch"
  }

  assert {
    condition     = output.associations_canonical_json == "{\"vpc-cccccccccccccccc\":{\"vpc_id\":\"vpc-cccccccccccccccc\",\"vpc_region\":\"eu-west-1\"},\"vpc-dddddddddddddddd\":{\"vpc_id\":\"vpc-dddddddddddddddd\",\"vpc_region\":null}}"
    error_message = "legacy_plus_associations: canonical json mismatch"
  }
}

run "vpc_region_conflict_in_list" {
  command = plan

  variables {
    vpc_associations = [
      { vpc_id = "vpc-samesamesame0001", vpc_region = "us-east-1" },
      { vpc_id = "vpc-samesamesame0001", vpc_region = "us-west-2" },
    ]
  }

  expect_failures = [
    terraform_data.vpc_association_validation,
  ]
}

run "legacy_conflicts_with_association_region" {
  command = plan

  variables {
    vpc_id     = "vpc-samesamesame0002"
    vpc_region = "us-east-1"
    vpc_associations = [
      { vpc_id = "vpc-samesamesame0002", vpc_region = "us-west-2" },
    ]
  }

  expect_failures = [
    terraform_data.vpc_association_validation,
  ]
}

run "null_and_explicit_same_provider_region_no_conflict" {
  command = plan

  variables {
    provider_default_region = "us-east-1"
    vpc_associations = [
      { vpc_id = "vpc-mixedregion00001", vpc_region = null },
      { vpc_id = "vpc-mixedregion00001", vpc_region = "us-east-1" },
    ]
  }

  assert {
    condition     = output.associations_canonical_json == "{\"vpc-mixedregion00001\":{\"vpc_id\":\"vpc-mixedregion00001\",\"vpc_region\":\"us-east-1\"}}"
    error_message = "null_and_explicit_same_provider_region_no_conflict: canonical json mismatch"
  }
}
