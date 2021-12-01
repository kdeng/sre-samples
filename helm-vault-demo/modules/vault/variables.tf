# Global
# variable "kubernetes_cluster_name" {}
variable "project_name" {
  default = "kefeng"
}

variable "aws_region" {
  default = "us-west-2"
}

# Ingress
variable "nginx_controller_class" {
  default = "nginx"
}

# Helm
variable "helm_repo" {
  default = "https://helm.releases.hashicorp.com"
}

variable "helm_vault_chart" {
  default = "hashicorp/vault"
}

variable "helm_vault_version" {
  default = "0.16.1"
}

variable "helm_vault_namespace" {
  default = "valut"
}

# Vault
variable "vault_environment" {
  
}

variable "vault_hostname" {}

variable "vault_replicas" {
  default = 3
}

variable "aws_dynamodb_table_name" {}
