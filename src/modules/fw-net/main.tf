resource "null_resource" "dependency_getter" {
  triggers = {
    my_dependencies = "${join(",", var.DEPENDENCY)}"
  }
}

resource "azurerm_virtual_network" "hubvnet" {
  depends_on = [
    null_resource.dependency_getter,
  ]
  name                = "hubvnet"
  address_space       = var.HUB_VNET_ADDR_SPACE
  location            = var.REGION
  resource_group_name = var.HUB_RG_NAME

  tags = {
    costcenter           = var.COST_CENTER
    deploymenttype       = var.DEPLOY_TYPE
    environmentinfo      = var.ENVIRONMENT
    notificationdistlist = var.NOTIFY_LIST
    ownerinfo            = var.OWNER_INFO
    platform             = var.PLATFORM
    sponsorinfo          = var.SPONSOR_INFO
  }
}

output "hub_vnet_name" {
  value       = azurerm_virtual_network.hubvnet.name
  description = ""
}

output "hub_vnet_id" {
  value       = azurerm_virtual_network.hubvnet.id
  description = ""
}

resource "azurerm_subnet" "azfwsubnet" {
  for_each             = var.HUB_SUBNET_NAMES
  name                 = each.key
  virtual_network_name = azurerm_virtual_network.hubvnet.name
  resource_group_name  = var.HUB_RG_NAME
  address_prefix       = each.value
}

output "subnet_id" {
  value = [
    for instance in azurerm_subnet.azfwsubnet :
    instance.id
  ]
}

resource "null_resource" "dependency_setter" {
  depends_on = [
    azurerm_subnet.azfwsubnet
  ]
}

output "depended_on" {
  value = "${null_resource.dependency_setter.id}-${timestamp()}"
}