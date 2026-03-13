
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.51.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {

  }
}



data "azurerm_kubernetes_cluster" "aks" {
  depends_on          = [module.aksWithAgicModule]
  name                = "aks-cluster"
  resource_group_name = "cluster-rg"

}

/*provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
} 
*/

provider "kubernetes" {
  host                   = module.aksWithAgicModule.host
  client_certificate     = base64decode(module.aksWithAgicModule.client_certificate)
  client_key             = base64decode(module.aksWithAgicModule.client_key)
  cluster_ca_certificate = base64decode(module.aksWithAgicModule.cluster_ca_certificate)
}

module "aksWithAgicModule" {
  source                            = "./aksWithAgicModule"
  resource_group_name               = var.resource_group_name
  resource_group_location           = var.resource_group_location
  virtual_network_name              = var.virtual_network_name
  virtual_network_address_prefix    = var.virtual_network_address_prefix
  aks_subnet_name                   = var.aks_subnet_name
  aks_cluster_name                  = var.aks_cluster_name
  aks_os_disk_size                  = var.aks_os_disk_size
  aks_node_count                    = var.aks_node_count
  aks_sku_tier                      = var.aks_sku_tier
  aks_vm_size                       = var.aks_vm_size
  kubernetes_version                = var.kubernetes_version
  aks_service_cidr                  = var.aks_service_cidr
  hostname                          = var.hostname
  aks_dns_service_ip                = var.aks_dns_service_ip
  aks_private_cluster               = var.aks_private_cluster
  app_gateway_subnet_address_prefix = var.app_gateway_subnet_address_prefix
  app_gateway_name                  = var.app_gateway_name
  app_gateway_tier                  = var.app_gateway_tier
  aks_enable_rbac                   = var.aks_enable_rbac
}



module "kubernetesModule" {
  source                    = "./kubernetesModule"
  replica_count             = var.replica_count
  environment               = var.environment
  namespace                 = var.namespace
  deployment_name           = var.deployment_name
  app_name                  = var.app_name
  service_name              = var.service_name
  container_image           = var.container_image
  ingress_name              = var.ingress_name
  ingress_host              = var.ingress_host
  resources                 = var.resources
  azure_ingress_annotations = var.azure_ingress_annotations
  namespace_chess           = var.namespace_chess
  depends_on                = [module.aksWithAgicModule]
}
