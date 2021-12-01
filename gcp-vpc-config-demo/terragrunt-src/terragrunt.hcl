# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load region-level variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  project_id  = local.project_vars.locals.project_id
  project_region = local.project_vars.locals.project_region
  env         = local.environment_vars.locals.environment

  ### Look all config.yml or config.yaml files, and merge the configurations
  root_deployments_dir       = get_parent_terragrunt_dir()
  relative_deployment_path   = path_relative_to_include()
  deployment_path_components = compact(split("/", local.relative_deployment_path))
  # Get a list of every path between root_deployments_directory and the path of
  # the deployment
  possible_config_dirs = [
    for i in range(0, length(local.deployment_path_components) + 1) :
    join("/", concat(
      [local.root_deployments_dir],
      slice(local.deployment_path_components, 0, i)
    ))
  ]
  # Generate a list of possible config files at every possible_config_dir
  # (support both .yml and .yaml)
  possible_config_paths = flatten([
    for dir in local.possible_config_dirs : [
      "${dir}/config.yml",
      "${dir}/config.yaml"
    ]
  ])
  # Load every YAML config file that exists into an HCL object
  file_configs = [
    for path in local.possible_config_paths :
    yamldecode(file(path)) if fileexists(path)
  ]
  # Merge the objects together, with deeper configs overriding higher configs
  merged_config = merge(local.file_configs...)
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google-beta" {
  region = "${local.project_region}"
  project = "${local.project_id}"
}
EOF
}

// remote_state {
//   backend = "local"
//   config = {
//       path = "./terraform.tfstate"
//   }
// }

// # Configure Terragrunt to automatically store tfstate files in an S3 bucket
// remote_state {
//   backend = "s3"
//   config = {
//     encrypt        = true
//     bucket         = "${get_env("TG_BUCKET_PREFIX", "")}terragrunt-example-terraform-state-${local.account_name}-${local.aws_region}-${local.environment}"
//     key            = "${path_relative_to_include()}/terraform.tfstate"
//     region         = local.aws_region
//     dynamodb_table = "terraform-locks"
//   }
//   generate = {
//     path      = "backend.tf"
//     if_exists = "overwrite_terragrunt"
//   }
// }


// # ---------------------------------------------------------------------------------------------------------------------
// # GLOBAL PARAMETERS
// # These variables apply to all configurations in this subfolder. These are automatically merged into the child
// # `terragrunt.hcl` config via the include block.
// # ---------------------------------------------------------------------------------------------------------------------

// # Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
// # where terraform_remote_state data sources are placed directly into the modules.
// inputs = merge(
//   local.account_vars.locals,
//   local.region_vars.locals,
//   local.environment_vars.locals,
// )

inputs = local.merged_config
