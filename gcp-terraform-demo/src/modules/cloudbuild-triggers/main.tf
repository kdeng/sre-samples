resource "google_cloudbuild_trigger" "cloudbuild_triggers" {

  count = length(var.cloudbuild_triggers)

  project     = var.project.id
  description = lookup(var.cloudbuild_triggers[count.index], "description")
  disabled    = lookup(var.cloudbuild_triggers[count.index], "disabled")
  filename    = lookup(var.cloudbuild_triggers[count.index], "filename")

  included_files  = lookup(var.cloudbuild_triggers[count.index], "includes")

  substitutions = lookup(var.cloudbuild_triggers[count.index], "substitutions")

  trigger_template {
    branch_name = lookup(var.cloudbuild_triggers[count.index], "branch")
    repo_name   = lookup(var.cloudbuild_triggers[count.index], "repository")
    dir         = lookup(var.cloudbuild_triggers[count.index], "directory")
  }

}
