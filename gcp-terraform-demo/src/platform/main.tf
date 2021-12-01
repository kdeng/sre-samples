###

# CloudBuild Trigger
module "cloudbuild-triggers" {
  source = "../modules/cloudbuild-triggers"
  project = var.project
  cloudbuild_triggers = var.cloudbuild_triggers
}
