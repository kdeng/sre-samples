
variable "credentials" {
  description = "provider credential path"
}

variable "project" {
  description = "Google project configuration"
  type        = map
  default = {
    "id"     = "mobilityos-dev"
    "region" = "australia-southeast1"
    "branchName"  = "master"
  }
}

variable "gke_container_network" {
  type = map
  default = {
    network_name = "gke-container-network"
    subnetwork_name = "gke-container-subnetwork"
  }
}

variable "gke_cluster_nginx" {
  description = "a collection of cluster configurations"
  type        = map
  default     = {
    "name" = "platform-ingress-nginx"
    "location" = "australia-southeast1"
    "initial_node_size" = "1"
    "min_node_size"     = "1"
    "max_node_size"     = "3"
    # "master_version"    = "1.15.4-gke.22"
    "min_master_version"      = "1.15.4-gke.22"
    "node_version"            = "1.15.4-gke.22"
    "gke_maintenance_window"  = "15:00"
    "node_pool_name"          = "primary-node-pool"
    "node_pool_machine_type"  = "n1-standard-1"
    # "network_name"            = "my-network"
    # "subnetwork_name"         = "my-australia-subnet"
    "preemptible"             = false
    "cluster_ipv4_cidr_block"  = "10.10.0.0/20"
    "services_ipv4_cidr_block" = "10.10.16.0/20"
    "istio_config_disabled"     = true
  }
}

# variable "gke_clusters_ambassador" {
#   description = "a collection of cluster configurations"
#   type        = map
#   default     = {
#     "name" = "platform-ingress-ambassador"
#     "location" = "australia-southeast1"
#     "initial_node_size" = "1"
#     "min_node_size"     = "1"
#     "max_node_size"     = "3"
#     "min_master_version"      = "1.15.4-gke.22"
#     "node_version"            = "1.15.4-gke.22"
#     "gke_maintenance_window"  = "15:00"
#     "node_pool_name"          = "platform-ambassador-node-pool"
#     "node_pool_machine_type" = "n1-standard-4"
#     "network_name"            = "my-network"
#     "subnetwork_name"         = "my-australia-subnet"
#     "preemptible"             = false
#     "cluster_ipv4_cidr_block"  = "10.11.0.0/20"
#     "services_ipv4_cidr_block" = "10.11.16.0/20"
#     "istio_config_disabled"     = true
#   }
# }

# variable "gke_clusters_istio" {
#   description = "a collection of cluster configurations"
#   type        = map
#   default     = {
#     "name" = "platform-ingress-istio"
#     "location" = "australia-southeast1"
#     "initial_node_size" = "1"
#     "min_node_size"     = "1"
#     "max_node_size"     = "3"
#     "min_master_version"      = "1.15.4-gke.22"
#     "node_version"            = "1.15.4-gke.22"
#     "gke_maintenance_window"  = "15:00"
#     "node_pool_name"          = "platform-istio-node-pool"
#     "node_pool_machine_type"  = "n1-standard-4"
#     "network_name"            = "my-network"
#     "subnetwork_name"         = "my-australia-subnet"
#     "preemptible"             = false
#     "cluster_ipv4_cidr_block"   = "10.12.0.0/20"
#     "services_ipv4_cidr_block"  = "10.12.16.0/20"
#     "istio_config_disabled"     = false
#   }
# }
