
resource "azurerm_kubernetes_cluster" "aks" {
  name                              = var.aks_cluster_name
  location                          = azurerm_resource_group.rg.location
  resource_group_name               = azurerm_resource_group.rg.name
  dns_prefix                        = var.aks_cluster_name
  private_cluster_enabled           = var.aks_private_cluster
  role_based_access_control_enabled = var.aks_enable_rbac
  sku_tier                          = var.aks_sku_tier

  default_node_pool {
    name            = "agentpool"
    node_count      = var.aks_node_count
    vm_size         = var.aks_vm_size
    os_disk_size_gb = var.aks_os_disk_size
    max_pods        = 100
    vnet_subnet_id  = data.azurerm_subnet.kubesubnet.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }


  network_profile {
    network_plugin = "azure"
    dns_service_ip = var.aks_dns_service_ip
    service_cidr   = var.aks_service_cidr
  }

  ingress_application_gateway {
    gateway_id = azurerm_application_gateway.appgw.id
  }

  depends_on = [
    azurerm_application_gateway.appgw
  ]
}

// --Identity 

data "azurerm_user_assigned_identity" "ingress" {
  name                = "ingressapplicationgateway-${azurerm_kubernetes_cluster.aks.name}"
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
}


resource "azurerm_user_assigned_identity" "aks" {
  name                = "${var.aks_cluster_name}-id"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

//------

# Role Assingments for AGIC identity 
resource "azurerm_role_assignment" "ra1" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.ingress.principal_id
 // principal_id         = azurerm_kubernetes_cluster.aks.ingress_application_gateway_identity[0].object_id
 lifecycle {
   ignore_changes = [ principal_id ]
 }
}

resource "azurerm_role_assignment" "ra2" {
  scope                = azurerm_virtual_network.vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_user_assigned_identity.ingress.principal_id
  lifecycle {
   ignore_changes = [ principal_id ]
 }
}

resource "azurerm_role_assignment" "ra3" {
  scope                = azurerm_application_gateway.appgw.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.ingress.principal_id
  lifecycle {
   ignore_changes = [ principal_id ]
 }

}

