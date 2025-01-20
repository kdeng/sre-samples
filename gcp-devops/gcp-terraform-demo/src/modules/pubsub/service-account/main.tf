resource "google_service_account" "pubsub_publisher" {
  project       = var.project.id
  account_id    = var.pubsub_publisher__account_id
  display_name  = var.pubsub_publisher__display_name
}

resource "google_service_account_key" "pubsub_publisher_key" {
  service_account_id  = google_service_account.pubsub_publisher.name
  public_key_type     = var.pubsub_public_key_type
  private_key_type    = var.pubsub_private_key_type
}

resource "local_file" "pubsub_publisher_key" {
  content  = base64decode(google_service_account_key.pubsub_publisher_key.private_key)
  filename = "${path.module}/../../../../../output/${var.project.id}-pubsub-publisher.json"
}

resource "google_project_iam_binding" "pubsub_publisher" {
  project   = var.project.id
  role      = var.pubsub_publisher__role
  members   = [
    "serviceAccount:${google_service_account.pubsub_publisher.email}"
  ]
}

resource "google_service_account" "pubsub_subscriber" {
  project       = var.project.id
  account_id    = var.pubsub_subscriber__account_id
  display_name  = var.pubsub_subscriber__display_name
}

resource "google_service_account_key" "pubsub_subscriber_key" {
  service_account_id  = google_service_account.pubsub_subscriber.name
  public_key_type     = var.pubsub_public_key_type
  private_key_type    = var.pubsub_private_key_type
}

resource "local_file" "pubsub_subscriber_key" {
  content  = base64decode(google_service_account_key.pubsub_subscriber_key.private_key)
  filename = "${path.module}/../../../../../output/${var.project.id}-pubsub-subscriber.json"
}

resource "google_project_iam_binding" "pubsub_subscriber" {
  project   = var.project.id
  role      = var.pubsub_subscriber__role
  members   = [
    "serviceAccount:${google_service_account.pubsub_subscriber.email}"
  ]
}
