
resource "google_storage_bucket" "static_bucket" {
  project   = var.project.id
  name      = "${var.project.id}-static"
  location  = "australia-southeast1"
  storage_class       = "REGIONAL"
  bucket_policy_only  =  "true"
  force_destroy       = true
}

resource "google_storage_bucket" "html_bucket" {
  project   = var.project.id
  name      = "${var.project.id}-html"
  location  = "australia-southeast1"
  storage_class       = "REGIONAL"
  bucket_policy_only  =  "true"
}

resource "google_storage_bucket_object" "archived_bucket" {
  name          = "archived/"
  content       = "Not really a directory, but it's empty."
  bucket        = google_storage_bucket.html_bucket.name
}

resource "google_cloud_scheduler_job" "cloud_scheduler__verify_update_scheduler" {
  project     = var.project.id
  region      = var.project.region
  name        = "update-check-scheduler"
  description = "Trigger a CloudBuild to verify update"

  schedule    = "30 4 * * *"
  time_zone   = "Pacific/Auckland"

  http_target {
    http_method = "POST"
    uri = "https://cloudbuild.googleapis.com/v1/projects/${var.project.id}/triggers/verify-update-check:run"

    oauth_token {
      service_account_email = var.cloud_scheduler_service_account_email
    }

    headers = {
      "Content-Type" = "application/json"
    }

    body = base64encode("{\"projectId\": \"${var.project.id}\", \"repoName\": \"github_verify-update-check\", \"dir\": \".\", \"branchName\": \"${var.project.branchName}\" }")

  }
}
