data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.project_region
}

locals {
  network_name    = "${var.project_id}-main-vpc"

  max_zone_length = length(data.google_compute_zones.available.names)

  public_subnets = [
    for idx,name in data.google_compute_zones.available.names: cidrsubnet(var.project_cidr, 8, idx + 1)
  ]
  private_subnets = [
    for idx,name in data.google_compute_zones.available.names: cidrsubnet(var.project_cidr, 8, idx + 101)
  ]
}

resource "google_compute_network" "this" {
  project       = var.project_id
  name          = local.network_name
  routing_mode  = var.routing_mode
  mtu           = var.vpc_network_mtu
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "this-public-subnet" {
  project       = var.project_id
  region        = var.project_region
  count         = length(local.public_subnets)
  name          = "public-subnet-${count.index+1}"
  ip_cidr_range = local.public_subnets[count.index]

  network       = google_compute_network.this.id
  private_ip_google_access  = false
}

resource "google_compute_subnetwork" "this-private-subnet" {
  region        = var.project_region
  project       = var.project_id
  count         = length(local.private_subnets)
  name          = "private-subnet-${count.index+1}"
  ip_cidr_range = local.private_subnets[count.index]
  network       = google_compute_network.this.id
  private_ip_google_access  = true
}

#
#module "vpc" {
#    source  = "terraform-google-modules/network/google"
#    version = "~> 3.0"
#
#    project_id   = var.project_id
#    network_name = local.network_name
#    routing_mode = "GLOBAL"
#    auto_create_subnetworks = false
#
#    subnets = concat(local.public_subnets, local.private_subnets)
#
#    // secondary_ranges = {
#    //     subnet-01 = [
#    //         {
#    //             range_name    = "subnet-01-secondary-01"
#    //             ip_cidr_range = "192.168.64.0/24"
#    //         },
#    //     ]
#
#    //     subnet-02 = []
#    // }
#
#    // routes = [
#    //     {
#    //         name                   = "egress-internet"
#    //         description            = "route through IGW to access internet"
#    //         destination_range      = "0.0.0.0/0"
#    //         tags                   = "egress-inet"
#    //         next_hop_internet      = "true"
#    //     },
#    //     {
#    //         name                   = "app-proxy"
#    //         description            = "route through proxy to reach app"
#    //         destination_range      = "10.50.10.0/24"
#    //         tags                   = "app-proxy"
#    //         next_hop_instance      = "app-proxy-instance"
#    //         next_hop_instance_zone = "us-west1-a"
#    //     },
#    // ]
#}
