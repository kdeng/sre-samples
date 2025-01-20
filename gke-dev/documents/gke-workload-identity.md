# GKE Workload Identity

```bash

cat /var/run/secrets/kubernetes.io/serviceaccount/token


export JWT_TOKEN=$(curl -sSL "https://gcr.io/v2/token?service=gcr.io&scope=registry:catalog:*" -u _token:`cat /var/run/secrets/kubernetes.io/serviceaccount/token` | jq --raw-output '.token')


curl -sSL -H "Authorization: Bearer $JWT_TOKEN" "https://gcr.io/v2/_catalog"


export JWT_TOKEN=$(curl -sSL "https://gcr.io/v2/token?service=gcr.io&scope=repository:kefeng-playground/api-demo:*" -u _token:`cat /var/run/secrets/kubernetes.io/serviceaccount/token` | jq --raw-output '.token')


curl -sSL -H "Authorization: Bearer $JWT_TOKEN" "https://gcr.io/v2/kefeng-playground/api-demo/tags/list" | jq '.tags'


curl -sSL -u "oauth2accesstoken:`cat /var/run/secrets/kubernetes.io/serviceaccount/token`" "https://gcr.io/v2/kefeng-playground/api-demo/tags/list"



```
