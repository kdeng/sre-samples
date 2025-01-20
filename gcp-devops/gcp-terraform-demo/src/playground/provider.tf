  provider "google-beta" {
    credentials = file(var.credentials)
    version = "2.20.0"
    project = var.project.id
    region  = var.project.region
  }
