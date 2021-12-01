# Get Ingress endpoint
data "kubernetes_service" "nginx" {
  metadata {
    name      = "${var.vault_environment}-${var.nginx_controller_class}-nginx-ingress-controller"
    namespace = "${var.vault_environment}-${var.nginx_controller_class}"
  }
}

output "kubernetes_ingress_load_balancer" {
  value = "${data.kubernetes_service.nginx.load_balancer_ingress.0.hostname}"
}

output "vault_user" {
  value = "${aws_iam_user.vault.name}"
}
