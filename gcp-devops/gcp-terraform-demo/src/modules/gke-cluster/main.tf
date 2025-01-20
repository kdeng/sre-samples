
resource "random_integer" "master-build-cidr_range_b" {
  min = 16
  max = 31
}

resource "random_integer" "master-build-cidr_range_c" {
  min = 1
  max = 254
}

resource "google_compute_network" "container_network" {
  project                 = var.project.id
  name                    = var.gke_container_network.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "container_subnetwork" {
  project = var.project.id
  name          = var.gke_container_network.subnetwork_name
  description   = "auto-created subnetwork for cluster ${var.gke_cluster_setting.name}"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.project.region
  network       = google_compute_network.container_network.self_link

  depends_on = [google_compute_network.container_network]
}

resource "google_container_cluster" "primary" {
  provider = google-beta
  project = var.project.id
  name     = var.gke_cluster_setting.name
  location = var.gke_cluster_setting.location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true

  initial_node_count        = var.gke_cluster_setting.initial_node_size

  min_master_version        = var.gke_cluster_setting.min_master_version
  node_version              = var.gke_cluster_setting.node_version

  addons_config {

    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    istio_config {
      disabled = var.gke_cluster_setting.istio_config_disabled
    }

  }

  # network     = "projects/${var.project.id}/global/networks/${var.gke_cluster_setting.network_name}"
  # subnetwork  = "projects/${var.project.id}/regions/${var.project.region}/subnetworks/${var.gke_cluster_setting.subnetwork_name}"
  network    = google_compute_network.container_network.name
  subnetwork = google_compute_subnetwork.container_subnetwork.name

  ip_allocation_policy {
    use_ip_aliases           = true
    cluster_ipv4_cidr_block  = var.gke_cluster_setting.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.gke_cluster_setting.services_ipv4_cidr_block
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.${random_integer.master-build-cidr_range_b.result}.${random_integer.master-build-cidr_range_c.result}.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      display_name = "Allow All IPs"
      cidr_block   = "0.0.0.0/0"
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.gke_cluster_setting.gke_maintenance_window
    }
  }

  # depends_on = [google_compute_subnetwork.container_subnetwork]

}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  project = var.project.id
  name       = var.gke_cluster_setting.node_pool_name
  location   = var.gke_cluster_setting.location
  cluster    = google_container_cluster.primary.name

  node_count  = var.gke_cluster_setting.min_node_size

  autoscaling {
    min_node_count = var.gke_cluster_setting.min_node_size
    max_node_count = var.gke_cluster_setting.max_node_size
  }

  node_config {
    preemptible  = var.gke_cluster_setting.preemptible
    machine_type = var.gke_cluster_setting.node_pool_machine_type

    metadata = {
      disable-legacy-endpoints = true
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      # "https://www.googleapis.com/auth/logging.write",
      # "https://www.googleapis.com/auth/monitoring",
      # "https://www.googleapis.com/auth/servicecontrol",
      # "https://www.googleapis.com/auth/trace.append",
      # "https://www.googleapis.com/auth/cloud-platform.read-only",
      # "https://www.googleapis.com/auth/devstorage.read_only",
      # "https://www.googleapis.com/auth/service.management.readonly"
    ]
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  depends_on = [google_container_cluster.primary]

}


# resource "google_container_node_pool" "primary_preemptible_nodes" {
#   project = var.project.id
#   name       = var.gke_cluster_setting.node_pool_name
#   location   = var.gke_cluster_setting.location
#   cluster    = google_container_cluster.primary.name

#   node_count  = var.gke_cluster_setting.min_node_size

#   autoscaling {
#     min_node_count = var.gke_cluster_setting.min_node_size
#     max_node_count = var.gke_cluster_setting.max_node_size
#   }

#   node_config {
#     preemptible  = var.gke_cluster_setting.preemptible
#     machine_type = var.gke_cluster_setting.node_pool_machine_type

#     metadata = {
#       disable-legacy-endpoints = true
#     }

#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform",
#       # "https://www.googleapis.com/auth/logging.write",
#       # "https://www.googleapis.com/auth/monitoring",
#       # "https://www.googleapis.com/auth/servicecontrol",
#       # "https://www.googleapis.com/auth/trace.append",
#       # "https://www.googleapis.com/auth/cloud-platform.read-only",
#       # "https://www.googleapis.com/auth/devstorage.read_only",
#       # "https://www.googleapis.com/auth/service.management.readonly"
#     ]
#   }

#   management {
#     auto_repair  = "true"
#     auto_upgrade = "true"
#   }

#   depends_on = [google_container_cluster.primary]

# }
