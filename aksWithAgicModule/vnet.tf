resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.virtual_network_address_prefix]

  subnet {
    name             = var.aks_subnet_name
    address_prefixes = [var.aks_subnet_address_prefix]

  }

  subnet {
    name             = var.appgw_subnet_name
    address_prefixes = [var.app_gateway_subnet_address_prefix]
  }
}

// data block to refer to APpGW
data "azurerm_subnet" "kubesubnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
}

data "azurerm_subnet" "appgwsubnet" {
  name                 = var.appgw_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
}