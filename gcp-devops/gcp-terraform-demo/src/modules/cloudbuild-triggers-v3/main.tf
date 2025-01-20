resource "google_cloudbuild_trigger" "cloudbuild_triggers_v3" {

  count = length(var.cloudbuild_triggers)

  project     = var.project.id
  name        = lookup(var.cloudbuild_triggers[count.index], "name")
  description = lookup(var.cloudbuild_triggers[count.index], "description")
  disabled    = lookup(var.cloudbuild_triggers[count.index], "disabled")
  filename    = lookup(var.cloudbuild_triggers[count.index], "filename")

  ignored_files   = lookup(var.cloudbuild_triggers[count.index], "excludes")
  included_files  = lookup(var.cloudbuild_triggers[count.index], "includes")

  substitutions = lookup(var.cloudbuild_triggers[count.index], "substitutions")

  github {
    owner = lookup(var.cloudbuild_triggers[count.index], "github_owner")
    name  = lookup(var.cloudbuild_triggers[count.index], "github_repository_name")
    push  = lookup(var.cloudbuild_triggers[count.index], "github_push")
  }

}
