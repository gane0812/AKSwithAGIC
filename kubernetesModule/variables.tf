variable "environment" {
  description = "Environment name (dev,stage,prod)"
}
variable "namespace" {
  description = "Kubernetes namespace name"
}
variable "namespace_chess" {
  description = "game-chess"
}

variable "deployment_name" {
  description = "Name of the Deployment"
}



variable "app_name" {
  description = "Name of the Pod App"

}

variable "replica_count" {
  description = "Number of replicas for deployment"

}

variable "container_image" {
  description = "Container image for the app"
}

variable "ingress_host" {
  description = <<EOF
   Hostname for ingress rule. 
   If you're using Azure AppGw as ingress controller. Use Front-end IP's DNS name. Example: "host.eastus.cloudapp.azure.com"
   EOF

}
variable "service_name" {
  description = "Name of Service"

}
variable "ingress_name" {
  description = "Name of Ingress"
}

variable "resources" {
  description = "Pod resource requests and Limits"
}

#Azure ingress annotations can be edited here.
variable "azure_ingress_annotations" {
  description = "Ingress Annotations for Azure App GateWay"
}

//-----
# Variables of Chess Game
variable "deployment_chess_name" {
  description = "Name of Deployment of Chess Game"
  default     = "deployment-chess"
}
variable "app_chess_name" {
  description = "Name of the Chess App"
  default     = "app-chess"
}
variable "container_chess_image" {
  description = "value"
  default     = "rmeira/chess"
}
variable "service_chess_name" {
  description = "Name of the Chess app Service"
  default     = "svc-chess"
}