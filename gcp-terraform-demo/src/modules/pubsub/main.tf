resource "google_pubsub_topic" "pubsub_topic" {
  project   = var.project.id
  name      = var.pubsub_topic__name
}

resource "google_pubsub_subscription" "subscription_one" {
  project   = var.project.id
  topic = google_pubsub_topic.pubsub_topic.name
  name  = var.subscription_one__settings.name

  ack_deadline_seconds = var.subscription_one__settings.ack_deadline_seconds

  labels = {
  }

  # We are using pull subscription strategy
  message_retention_duration = var.subscription_one__settings.message_retention_duration
  retain_acked_messages = var.subscription_one__settings.retain_acked_messages
  expiration_policy {
    # leave it blank, so that subscription never expire
    ttl = ""
  }

}


resource "google_pubsub_subscription" "subscription_two" {
  project   = var.project.id
  topic = google_pubsub_topic.pubsub_topic.name
  name  = var.subscription_two__settings.name

  ack_deadline_seconds = var.subscription_two__settings.ack_deadline_seconds

  labels = {
  }

  # We are using pull subscription strategy
  message_retention_duration = var.subscription_two__settings.message_retention_duration
  retain_acked_messages = var.subscription_two__settings.retain_acked_messages
  expiration_policy {
    # leave it blank, so that subscription never expire
    ttl = ""
  }

}


resource "google_pubsub_subscription" "subscription_three" {
  project   = var.project.id
  topic = google_pubsub_topic.pubsub_topic.name
  name  = var.subscription_three__settings.name

  ack_deadline_seconds = var.subscription_three__settings.ack_deadline_seconds

  labels = {
  }

  # We are using pull subscription strategy
  message_retention_duration = var.subscription_three__settings.message_retention_duration
  retain_acked_messages = var.subscription_three__settings.retain_acked_messages
  expiration_policy {
    # leave it blank, so that subscription never expire
    ttl = ""
  }

}

