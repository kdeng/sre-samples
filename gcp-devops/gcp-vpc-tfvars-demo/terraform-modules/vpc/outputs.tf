output "public_subnets" {
  value = local.public_subnets
}

output "private_subnets" {
  value = local.private_subnets
}

output "vpc_id" {
  value = google_compute_network.this.id
}

output "public_subnet_ids" {
  value = google_compute_subnetwork.this-public-subnet.*.id
}

output "private_subnet_ids" {
  value = google_compute_subnetwork.this-private-subnet.*.id
}

output "vpc_zones" {
  value = data.google_compute_zones.available.names
}
