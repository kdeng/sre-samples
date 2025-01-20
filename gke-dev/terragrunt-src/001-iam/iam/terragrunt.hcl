locals {
  # Automatically load project-level variables
  project_vars      = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  # Automatically load envrionment-level variables
  environment_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  # Automatically load regional-level variables
  regional_vars     = read_terragrunt_config(find_in_parent_folders("regional.hcl"))

  # Extract the variables we need for easy access
  project_id      = local.project_vars.locals.project_id
  project_region  = local.regional_vars.locals.project_region
  env_region      = local.regional_vars.locals.env_region
  environment     = local.environment_vars.locals.environment

  service_account_name  = "${local.project_id}-${local.env_region}-${local.environment}-sa"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

terraform {
  source = "${path_relative_from_include()}/.././/terraform-modules/iam"
}

inputs = {
  service_account_name          = local.service_account_name
  service_account_display_name  = local.service_account_name
}
