
# variable "credentials" {
#   description = "provider credential path"
# }


# variable "idx" {
#   description = "index"
# }

variable "project" {
  description = "Google project configuration"
  type        = map
  default = {
    "id"     = "application-dev"
    "region" = "australia-southeast1"
    "branchName"  = "master"
  }
}

variable "gke_cluster_setting" {
  type = map
}

variable "gke_container_network" {
  type = map
}
