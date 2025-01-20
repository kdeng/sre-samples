variable "credentials" {
  description = "provider credential path"
}

variable "project" {
  description = "Google project configuration"
  type        = map
  default = {
    "id"          = "application-dev"
    "region"      = "us-central1"
    "branchName"  = "develop"
  }
}

variable "cloud_scheduler_service_account_email" {
  description   = "Default Service Account for cloud scheduler job to access CloudBuild"
  default       = "cloud-scheduler@application-dev.iam.gserviceaccount.com"
}

variable "cloudbuild_triggers" {
  description = "A collection of all cloudbuild triggers"
  type        = list
  default = [
    {
      "description" = "dev"
      "repository"  = "github_build-dev"
      "branch"      = "develop"
      "filename"    = "cloudbuild/cloudbuild.yaml"
      "directory"   = "."
      "disabled"    = false
      "includes"    = ["**/**"]
      "substitutions" = {
        "_DEBUG"        = false
        "_TARGET_ENVIRONMENT"  = "dev"
        "_TARGET_PROJECT_ID"   = "app-dev"
      }
    },
  ]
}

variable "cloudbuild_triggers_v2" {
  type = list
  default = [
    {
      "description" = "Verify update"
      "name"        = "verify-update"
      "repository"  = "github_verify-update"
      "branch"      = "develop"
      "filename"    = "cloudbuild/cloudbuild-verify-update.yaml"
      "directory"   = "."
      "disabled"    = true
      "includes"    = ["**/**"]
      "substitutions" = {
        "_DEBUG"        = false
        "_GRAPH_BUILD_TRIGGER_ID" = "build-new-html"
      }
    },
    {
      "description" = "Build HTML"
      "name"        = "build-new-html"
      "repository"  = "github_build-html"
      "branch"      = "develop"
      "filename"    = "cloudbuild/cloudbuild-build-html.yaml"
      "directory"   = "."
      "disabled"    = true
      "includes"    = ["**/**"]
      "substitutions" = {
        "_DEBUG"        = false
      }
    }
  ]
}
