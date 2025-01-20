locals {
  zone_idx = random_integer.zone_idx.result
  selected_zone = var.project_zones[local.zone_idx]
  selected_public_subnetwork = var.public_subnetwork_ids[local.zone_idx]
  selected_private_subnetwork = var.private_subnetwork_ids[local.zone_idx]
  instance_name = var.instance_name == "" || var.instance_name == null ? "${var.project_id}-${var.project_region}-gce" : var.instance_name
}

resource "random_integer" "zone_idx" {
  max          = length(var.project_zones) - 1
  min          = 0
}

resource "google_compute_instance" "public_instance" {
  project      = var.project_id
  name         = "${local.instance_name}-public"
  machine_type = var.machine_type
  zone         = local.selected_zone

  boot_disk {
    auto_delete = true
    mode        = "READ_WRITE"
    initialize_params {
      size  = 10
      image = "debian-cloud/debian-9"

    }
  }

  network_interface {
    network = var.network_id
    subnetwork = local.selected_public_subnetwork
  }

  #  service_account {
  #    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  #    email  = google_service_account.default.email
  #    scopes = ["cloud-platform"]
  #  }

  metadata_startup_script = "echo hi > /test.txt"

  tags = []

  labels = {
    terraform   = "true"
    environment = lower(var.environment)
    public      = "true"
  }
}


resource "google_compute_instance" "private_instance" {
  project      = var.project_id
  name         = "${local.instance_name}-private"
  machine_type = var.machine_type
  zone         = local.selected_zone

  boot_disk {
    auto_delete = true
    mode        = "READ_WRITE"
    initialize_params {
      size  = 10
      image = "debian-cloud/debian-9"

    }
  }

  network_interface {
    network = var.network_id
    subnetwork = local.selected_private_subnetwork
  }

  #  service_account {
  #    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  #    email  = google_service_account.default.email
  #    scopes = ["cloud-platform"]
  #  }

  metadata_startup_script = "echo hi > /test.txt"

  tags = []

  labels = {
    terraform   = "true"
    environment = lower(var.environment)
    private     = "true"
  }
}
