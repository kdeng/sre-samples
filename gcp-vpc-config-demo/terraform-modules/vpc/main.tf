data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.project_region
}

locals {
  network_name    = "${var.project_id}-main-vpc"

  max_zone_length = length(data.google_compute_zones.available.names)

  public_subnets = [
    for idx,name in data.google_compute_zones.available.names: {
      subnet_name   = "public-subnet-${idx+1}"
      subnet_region = var.project_region
      subnet_ip     = cidrsubnet(var.project_cidr, 8, idx + 1)
      subnet_private_access = "false"
      description   = "public-subnet-${idx+1}"
    }
  ]
  private_subnets = [
    for idx,name in data.google_compute_zones.available.names: {
      subnet_name   = "private-subnet-${idx+1}"
      subnet_region = var.project_region
      subnet_ip     = cidrsubnet(var.project_cidr, 8, idx + 101)
      subnet_private_access = "true"
      description   = "private-subnet-${idx+1}"
    }
  ]
}

output "public_subnets" {
  value = local.public_subnets
}

output "private_subnets" {
  value = local.private_subnets
}

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 3.0"

    project_id   = var.project_id
    network_name = local.network_name
    routing_mode = "GLOBAL"
    auto_create_subnetworks = false

    subnets = concat(local.public_subnets, local.private_subnets)

    // secondary_ranges = {
    //     subnet-01 = [
    //         {
    //             range_name    = "subnet-01-secondary-01"
    //             ip_cidr_range = "192.168.64.0/24"
    //         },
    //     ]

    //     subnet-02 = []
    // }

    // routes = [
    //     {
    //         name                   = "egress-internet"
    //         description            = "route through IGW to access internet"
    //         destination_range      = "0.0.0.0/0"
    //         tags                   = "egress-inet"
    //         next_hop_internet      = "true"
    //     },
    //     {
    //         name                   = "app-proxy"
    //         description            = "route through proxy to reach app"
    //         destination_range      = "10.50.10.0/24"
    //         tags                   = "app-proxy"
    //         next_hop_instance      = "app-proxy-instance"
    //         next_hop_instance_zone = "us-west1-a"
    //     },
    // ]
}
