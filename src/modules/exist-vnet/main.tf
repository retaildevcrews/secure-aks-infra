data azurerm_virtual_network exist-vnet {
  name                = var.EXISTING_VNET_NAME
  resource_group_name = var.EXISTING_VNET_RG
}

data azurerm_subnet exist-subnet {
  name                 = var.EXISTING_SUBNET_NAME
  virtual_network_name = data.azurerm_virtual_network.exist-vnet.name
  resource_group_name  = var.EXISTING_VNET_RG
}

output subnet_id {
  value = data.azurerm_subnet.exist-subnet.id
}