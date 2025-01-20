variable "project" {
  type = map
}

variable "pubsub_public_key_type" {
  description = "Deefault public key type"
  default     = "TYPE_X509_PEM_FILE"
}

variable "pubsub_private_key_type" {
  description = "Default private key type"
  default     = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

variable "pubsub_publisher__account_id" {
  description = "Account ID of pubsub publisher service account ID"
  default     = "pubsub-publisher"
}

variable "pubsub_publisher__display_name" {
  description = "Display name of pubsub publisher service account"
  default     = "pubsub publisher service account"
}

variable "pubsub_publisher__role" {
  description = "Default pubsub publisher role"
  default     = "roles/pubsub.publisher"
}

variable "pubsub_subscriber__account_id" {
  description = "Account ID of pubsub subscriber service account ID"
  default     = "pubsub-subscriber"
}

variable "pubsub_subscriber__display_name" {
  description = "Display name of pubsub subscriber service account"
  default     = "pubsub subscriber service account"
}

variable "pubsub_subscriber__role" {
  description = "Default pubsub subscriber role"
  default     = "roles/pubsub.subscriber"
}
