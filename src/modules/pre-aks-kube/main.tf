
resource "null_resource" "dependency_getter" {
  triggers = {
    my_dependencies = "${join(",", var.DEPENDENCY)}"
  }
}

resource random_integer uuid {
  min = 400
  max = 450
}

resource "azurerm_route_table" "vdmzudr" {
  depends_on = [
    null_resource.dependency_getter,
  ]
  name                = "${var.CLUSTER_ID}routetable"
  location            = var.REGION
  resource_group_name = var.AKS_RG_NAME


  route {
    name                   = "vDMZ"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.AZFW_PRIV_IP
  }
}

resource "azurerm_subnet_route_table_association" "vdmzudr" {
  subnet_id      = var.AKS_SUBNET_ID
  route_table_id = azurerm_route_table.vdmzudr.id
}

resource "azurerm_firewall_network_rule_collection" "netruleazfw-temp" {
  name                = "AzureFirewallNetCollection-${var.CLUSTER_ID}API-TEMP"
  azure_firewall_name = var.AZFW_NAME
  resource_group_name = var.HUB_RG_NAME
  priority            = random_integer.uuid.result
  action              = "Allow"

  rule {
    name = "AllowTempAPIAccess"
    source_addresses = [
      "*",
    ]
    destination_ports = [
      "443"
    ]
    destination_addresses = [
      "AzureCloud.${var.REGION}"
    ]
    protocols = [
      "TCP"
    ]
  }
}

resource "null_resource" "dependency_setter" {
  depends_on = [
    azurerm_firewall_network_rule_collection.netruleazfw-temp
  ]
}

output "depended_on" {
  value = "${null_resource.dependency_setter.id}-${timestamp()}"
}