  provider "google-beta" {
    credentials = file(var.credentials)
    project = var.project.id
    region  = var.project.region
    version = "~> 2.17"
  }
