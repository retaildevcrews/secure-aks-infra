resource "null_resource" "dependency_getter" {
  triggers = {
    my_dependencies = "${join(",", var.DEPENDENCY)}"
  }
}

resource "null_resource" "kubenet_udr" {
  depends_on = [
    null_resource.dependency_getter,
  ]
  provisioner "local-exec" {
    command = "../modules/post-aks-kube/rtnsg-fix.sh"

    environment = {
      AKS_VNET_RG      = var.AKS_RG_NAME
      AKS_VNET_NAME    = var.AKS_VNET_NAME
      AKS_SUBNET_NAME  = var.AKS_SUBNET_NAME
      AZFW_INT_IP      = var.AZFW_PRIV_IP
      AZ_CLIENT_ID     = var.TF_CLIENT_ID
      AZ_CLIENT_SECRET = var.TF_CLIENT_SECRET
      AZ_TENANT_ID     = var.TF_TENANT_ID
    }
  }

  # provisioner "local-exec" {
  #   when    = destroy
  #   command = "./rtnsg-rm.sh"

  #   environment = {
  #     AKS_VNET_RG      = var.AKS_RG_NAME
  #     AKS_VNET_NAME    = var.AKS_VNET_NAME
  #     AKS_SUBNET_NAME  = var.AKS_SUBNET_NAME
  #     AZ_CLIENT_ID     = var.TF_CLIENT_SECRET
  #     AZ_CLIENT_SECRET = var.TF_CLIENT_ID
  #     AZ_TENANT_ID     = var.TF_TENANT_ID
  #   }
  # }
}

data dns_a_record_set apiIP {
  host = var.AKS_API_FQDN
}

resource random_integer priorityid {
  min = 205
  max = 350
}

resource "azurerm_firewall_network_rule_collection" "netruleazfw" {
  name                = "AzureFirewallNetCollection-API${var.CLUSTER_ID}"
  azure_firewall_name = var.AZFW_NAME
  resource_group_name = var.AZFW_RG_NAME
  priority            = random_integer.priorityid.result
  action              = "Allow"

  depends_on = [
    data.dns_a_record_set.apiIP
  ]
  rule {
    name = "AllowAPIServer"
    source_addresses = [
      "*",
    ]
    destination_ports = [
      "443"
    ]
    destination_addresses = [
      "${join(",", data.dns_a_record_set.apiIP.addrs)}"
    ]
    protocols = [
      "TCP"
    ]
  }
}

resource "null_resource" "dependency_setter" {
  depends_on = [
    null_resource.kubenet_udr,
    azurerm_firewall_network_rule_collection.netruleazfw
  ]
}

output "depended_on" {
  value = "${null_resource.dependency_setter.id}-${timestamp()}"
}