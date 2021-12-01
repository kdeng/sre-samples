variable "credentials" {
  description = "provider credential path"
}

variable "project" {
  description = "Google project configuration"
  type        = map
  default = {
    "id"     = "app-dev"
    "region" = "us-central1"
  }
}

variable "cloudbuild_triggers" {
  description = "A collection of all cloudbuild triggers"
  type        = list
  default = [
    ################################################################################
    ### Platform Infrastructure
    ################################################################################
    {
      "description" = "Deployment | platform-builder"
      "repository"  = "github_terraform-resources"
      "branch"      = "master"
      "filename"    = "cloudbuild/cloudbuild.yaml"
      "directory"   = "."
      "disabled"    = true
      "includes"    = ["./cloudbuild/cloudbuild-deploy-platform.yaml", "./platform/terraform/platform-builder/**"]
      "substitutions" = {
        "_DEBUG"        = true
        "_MODULE"       = "platform-builder"
        "_ENVIRONMENT"  = "application-dev"
      }
    },
    ################################################################################
    ### Java Tools
    ################################################################################
    {
      "description" = "Tiles | tile-release"
      "repository"  = "github_java-tools"
      "branch"      = "master"
      "filename"    = "cloudbuild/cloudbuild.yaml"
      "directory"   = "tiles/tile-release"
      "disabled"    = false
      "includes"    = ["tiles/tile-release/**"]
      "substitutions" = {
        "_DEBUG"        = false
        "_REPO_NAME"    = "java-tools"
        "_ARTIFACT_ID"  = "tile-release"
      }
    },
  ]
}

