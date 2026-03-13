variable "environment" {
  description = "Environment name (dev,stage,prod)"
  type        = string
  default     = "dev"
}
variable "namespace" {
  description = "Kubernetes namespace name"
  type        = string
  default     = "game-2048"
}
variable "namespace_chess" {
  description = "Kubernetes namespace name"
  type        = string
  default     = "game-chess"
}


variable "deployment_name" {
  description = "Name of the Deployment"
  type        = string
  default     = "deployment-2048"
}

variable "app_name" {
  description = "Name of the Pod App"
  type        = string
  default     = "app-2048"
}

variable "replica_count" {
  description = "Number of replicas for deployment"
  type        = number
  default     = 1
}

variable "container_image" {
  description = "Container image for the app"
  type        = string
  default     = "public.ecr.aws/l6m2t8p7/docker-2048:latest"
  #default = "alexwhen/docker-2048"
}

variable "ingress_host" {
  description = <<EOF
   Hostname for ingress rule. 
   If you're using Azure AppGw as ingress controller. Use Front-end IP's DNS name. Example: "host.eastus.cloudapp.azure.com"
   EOF
  type        = string
  default     = "gane.eastus.cloudapp.azure.com"
}
variable "service_name" {
  description = "Name of Service"
  type        = string
  default     = "service-2048"
}
variable "ingress_name" {
  description = "Name of Ingress"
  type        = string
  default     = "ingress-game"
}

variable "resources" {
  description = "Pod resource requests and Limits"
  type = object({
    limits   = map(string)
    requests = map(string)
  })
  default = {
    requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
    limits = {
      cpu    = "250m"
      memory = "256Mi"
    }
  }
}

variable "azure_ingress_annotations" {
  description = "Ingress Annotations for Azure App GateWay"
  type        = map(string)

  default = {
    "kubernetes.io/ingress.class"                     = "azure-application-gateway"
    "appgw.ingress.kubernetes.io/backend-path-prefix" = "/"
    // "appgw.ingress.kubernetes.io/use-private-ip"      = "true"
  }
}