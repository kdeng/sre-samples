provider "aws" {
  region                      = var.project_region
  skip_credentials_validation = true
  skip_metadata_api_check     = true
}