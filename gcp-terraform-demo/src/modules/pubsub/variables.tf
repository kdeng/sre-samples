variable "project" {
  type = map
}

variable "pubsub_topic__name" {
  description   = "Default pubsub topic name"
  default       = "pubsub-topic"
}

variable "subscription_one__settings" {
  description = "subscription one"
  type        = map
  default     = {

    name                  = "subscription-one"

    ## https://www.terraform.io/docs/providers/google/r/pubsub_subscription.html#ack_deadline_seconds
    ## Default ack_deadline_seconds in second for firebase subscription
    ack_deadline_seconds  = 120

    ## https://www.terraform.io/docs/providers/google/r/pubsub_subscription.html#message_retention_duration
    ## If the message be retained more than 10 mins (600seconds), it would be removed from backlog
    message_retention_duration  = "600s"

    ## https://www.terraform.io/docs/providers/google/r/pubsub_subscription.html#retain_acked_messages
    retain_acked_messages       = true

  }
}

variable "subscription_two__settings" {
  description = "Subscription two"
  type        = map
  default     = {

    name                  = "subscription-two"

    ## https://www.terraform.io/docs/providers/google/r/pubsub_subscription.html#ack_deadline_seconds
    ## Default ack_deadline_seconds in second for firebase subscription
    ack_deadline_seconds  = 120

    ## https://www.terraform.io/docs/providers/google/r/pubsub_subscription.html#message_retention_duration
    ## If the message be retained more than 10 mins (600seconds), it would be removed from backlog
    message_retention_duration  = "600s"

    ## https://www.terraform.io/docs/providers/google/r/pubsub_subscription.html#retain_acked_messages
    retain_acked_messages       = true

  }
}

variable "subscription_three__settings" {
  description = "Subscription three"
  type        = map
  default     = {

    name                  = "subscription-three"

    ## https://www.terraform.io/docs/providers/google/r/pubsub_subscription.html#ack_deadline_seconds
    ## Default ack_deadline_seconds in second for firebase subscription
    ack_deadline_seconds  = 15

    ## https://www.terraform.io/docs/providers/google/r/pubsub_subscription.html#message_retention_duration
    ## If the message be retained more than 10 mins (600seconds), it would be removed from backlog
    message_retention_duration  = "600s"

    ## https://www.terraform.io/docs/providers/google/r/pubsub_subscription.html#retain_acked_messages
    retain_acked_messages       = true

  }
}


