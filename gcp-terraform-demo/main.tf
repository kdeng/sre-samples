
terraform {
  required_version = ">= 0.12"
}

# module "platform" {
#   source = "./src/platform"
#   credentials = var.credentials
# }

# module "dev" {
#   source = "./src/dev"
#   credentials = var.credentials
# }

module "playground" {
  source = "./src/playground"
  credentials = var.credentials
}

variable "credentials" {
  description = "provider credential path"
}
