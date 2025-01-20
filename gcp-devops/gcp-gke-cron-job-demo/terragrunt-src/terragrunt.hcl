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
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.0.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.6.1"
    }
  }
}

provider "google-beta" {
  region = "${local.project_region}"
  project = "${local.project_id}"
}

provider "null" {
  # Configuration options
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
