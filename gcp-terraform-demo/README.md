# A simple sample of Infrastructure as Code

This is the core repository to achieve infrastructure as code.

## Build platform

### List terraform workspace

```bash
  terraform workspace list
```

### Select correct project emnvironment

```bash
  terraform workspace select build-application-dev
```

### Initialise local terraform state files

```bash
  terraform init
```

### Install all resources

```bash
  terraform apply -auto-approve -refresh -target=module.build-application-dev
```

### Destroy all resources

```bash
  terraform destroy -auto-approve -refresh -target=module.build-application-dev
```

### Upload terraform state

```bash
  gsutil -m cp -r ./terraform.tfstate.d gs://infrastructure-terraform-state/
```

## Module per project

One module per project / environment.
