variable "project" {
  type = map
}

variable "cloud_scheduler_service_account_email" {
  type = string
}

variable "cloudbuild_triggers" {
  type = list
}
