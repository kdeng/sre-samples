KIND_CLUSTER_NAME?=kind

vault:
	helm repo add hashicorp https://helm.releases.hashicorp.com
	helm repo update
	helm install vault hashicorp/vault

vault-upgrade:
	helm upgrade --install vault hashicorp/vault -f ./helm/values.yaml

external-secrets:
	helm repo add external-secrets https://external-secrets.github.io/kubernetes-external-secrets/
	helm repo update
	helm install external-secrets external-secrets/kubernetes-external-secrets
