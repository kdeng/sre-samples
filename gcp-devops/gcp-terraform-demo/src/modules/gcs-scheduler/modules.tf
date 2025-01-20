module "cloudbuild-triggers_v2" {
  source = "../cloudbuild-triggers-v2"
  project = var.project
  cloudbuild_triggers = var.cloudbuild_triggers
}
