output "public_instance_id" {
  value = google_compute_instance.public_instance.instance_id
}

output "private_instance_id" {
  value = google_compute_instance.private_instance.instance_id
}
