# AKS + Application Gateway Ingress Controller (AGIC) — Terraform Deployment

Deploy two containerised web applications on Azure Kubernetes Service, exposed through an Azure Application Gateway using the AGIC add-on. All infrastructure is provisioned with Terraform.

---

## Architecture

Both applications share a single namespace (`game-2048`). The Application Gateway routes traffic by URL path, with AGIC dynamically managing all routing rules from the Kubernetes Ingress resources.


```bash
az login
az account set --subscription "<your-subscription-id>"
```

---

## Configuration

Clone the repo and create a `terraform.tfvars` file:

```hcl
resource_group_name = "Cluster-rg"
location            = "eastus"
cluster_name        = "my-aks-cluster"
appgw_name          = "ApplicationGateway1"
dns_label           = "game"
environment         = "dev"

# Set your own hostname here — this becomes the Ingress host and public DNS label.
# Example: "game" resolves to game.eastus.cloudapp.azure.com
ingress_host        = "game.eastus.cloudapp.azure.com"
```

> `ingress_host` maps to `var.ingress_host` in the Kubernetes module and is used as the hostname on both Ingress resources. Set it to match your chosen DNS label and Azure region.

---

## Deployment

Because the Kubernetes provider depends on a live AKS cluster, apply in two phases:

```bash
terraform init

# Phase 1 — provision AKS, App Gateway, and networking
terraform apply -target=module.aksWithAgicModule

# Phase 2 — deploy Kubernetes resources (namespaces, services, ingresses)
terraform apply
```

---

## Accessing the Applications

Once both phases complete, your applications are available at:

```
http://<ingress_host>/2048   →  2048 game
http://<ingress_host>/chess  →  Chess game
```

For example, if you set `ingress_host = "game.eastus.cloudapp.azure.com"`:

```
http://game.eastus.cloudapp.azure.com/2048
http://game.eastus.cloudapp.azure.com/chess
```
## What I Built

End-to-end cloud-native infrastructure on Azure using Infrastructure as Code:

- **AKS** cluster with AGIC add-on for native Application Gateway integration
- **Path-based routing** — two apps served from the same public IP, differentiated by URL path
- **Terraform module structure** — AKS/networking in one module, Kubernetes resources in another
- **Two-phase apply pattern** — solves Kubernetes provider initialisation timing against a freshly created cluster
- **AGIC/Terraform separation** — Terraform owns the infrastructure skeleton; AGIC owns all routing rules via `lifecycle.ignore_changes`