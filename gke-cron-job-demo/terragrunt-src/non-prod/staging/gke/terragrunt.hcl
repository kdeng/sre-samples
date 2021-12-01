locals {
  # Automatically load project-level variables
  project_vars     = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  env            = local.environment_vars.locals.environment
  project_id     = local.project_vars.locals.project_id
  project_region = local.project_vars.locals.project_region
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path                             = "../vpc"
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs                            = {
    vpc_id             = "fake_vpc_id"
    public_subnet_ids  = ["fake_subnet_id"]
    private_subnet_ids = ["fake_subnet_id"]
    vpc_zones          = ["fake_zones"]
    project_cidr       = "fake_project_cidr"
  }
}

terraform {
  source = "${path_relative_from_include()}/.././/terraform-modules/gke"
}

inputs = {
  project_id             = local.project_id
  project_region         = local.project_region
  project_zones          = dependency.vpc.outputs.vpc_zones
  project_cidr           = dependency.vpc.outputs.project_cidr
  environment            = local.env
  network_id             = dependency.vpc.outputs.vpc_id
  public_subnetwork_ids  = dependency.vpc.outputs.public_subnet_ids
  private_subnetwork_ids = dependency.vpc.outputs.private_subnet_ids
}
