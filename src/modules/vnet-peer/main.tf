resource "null_resource" "dependency_getter" {
  triggers = {
    my_dependencies = "${join(",", var.DEPENDENCY)}"
  }
}

resource "azurerm_virtual_network_peering" "hub-to-aks" {
  name                         = "hub-to-${var.CLUSTER_ID}"
  resource_group_name          = var.HUB_RG_NAME
  virtual_network_name         = var.HUB_VNET_NAME
  remote_virtual_network_id    = var.AKS_VNET_ID
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "aks-to-hub" {
  name                         = "${var.CLUSTER_ID}-to-hub"
  resource_group_name          = var.AKS_RG_NAME
  virtual_network_name         = var.AKS_VNET_NAME
  remote_virtual_network_id    = var.HUB_VNET_ID
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "null_resource" "dependency_setter" {
  depends_on = [
    azurerm_virtual_network_peering.aks-to-hub,
    azurerm_virtual_network_peering.hub-to-aks
  ]
}

output "depended_on" {
  value = "${null_resource.dependency_setter.id}-${timestamp()}"
}