# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "${path_relative_from_include()}/.././/terraform-modules/cloudrun"
}

inputs = {
  service_name = "kefeng-cloudrun"
}
