###

# pubsub resources
module "pubsub" {
  source = "../modules/pubsub"
  project = var.project
}

module "cloudbuild-triggers" {
  source = "../modules/cloudbuild-triggers"
  project = var.project
  cloudbuild_triggers = var.cloudbuild_triggers
}

module "gtfs-feed-graph-builder" {
  source = "../modules/gtfs-feed-graph-builder"
  project = var.project
  cloud_scheduler_service_account_email = var.cloud_scheduler_service_account_email
  cloudbuild_triggers = var.cloudbuild_triggers_v2
}

