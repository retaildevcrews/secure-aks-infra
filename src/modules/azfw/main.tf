resource "null_resource" "dependency_getter" {
  triggers = {
    my_dependencies = "${join(",", var.DEPENDENCY)}"
  }
}

resource random_integer uuid {
  min = 01
  max = 99
}

resource "azurerm_public_ip" "azfwpip" {
  depends_on = [
    null_resource.dependency_getter,
  ]
  name                = "azfwpip${random_integer.uuid.result}"
  location            = var.REGION
  resource_group_name = var.HUB_RG_NAME
  allocation_method   = "Static"
  sku                 = "Standard"

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

output "azfw_pip" {
  value = azurerm_public_ip.azfwpip.ip_address
}



resource "azurerm_firewall" "hubazfw" {
  depends_on = [
    null_resource.dependency_getter,
  ]
  name                = "hubazfw${random_integer.uuid.result}-${var.REGION}"
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

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.HUB_SUBNET_ID
    public_ip_address_id = azurerm_public_ip.azfwpip.id
  }
}

resource "azurerm_firewall_application_rule_collection" "appruleazfw" {
  depends_on = [
    null_resource.dependency_getter,
  ]
  name                = "AzureFirewallAppCollection"
  azure_firewall_name = azurerm_firewall.hubazfw.name
  resource_group_name = var.HUB_RG_NAME
  priority            = 100
  action              = "Allow"
  rule {
    name = "hcp_rules"
    source_addresses = [
      "*",
    ]
    target_fqdns = [
      "*.hcp.${var.REGION}.azmk8s.io",
      "*.tun.${var.REGION}.azmk8s.io",
      "mcr.microsoft.com",
      "*.data.mcr.microsoft.com",
      "*.cdn.mscr.io",
      "packages.microsoft.com",
      "acs-mirror.azureedge.net",
      "login.microsoftonline.com",
      "management.azure.com",
      "upstreamartifacts.blob.core.windows.net" #TODO Eddie V. 3/25/2020 - Remove when AKS Patch is applied for incorrect URL
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }
  rule {
    name = "dockerReg_rules"
    source_addresses = [
      "*",
    ]
    target_fqdns = [
      var.DOCKER_REGISTRY, #FQDN for Private registry
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }
  rule {
    name = "azmon_support_rules"
    source_addresses = [
      "*",
    ]
    target_fqdns = [
      "dc.services.visualstudio.com",
      "*.ods.opinsights.azure.com",
      "*.oms.opinsights.azure.com",
      "*.microsoftonline.com",
      "*.monitoring.azure.com",
    ]

    protocol {
      port = "443"
      type = "Https"
    }
  }
  rule {
    name = "aks_support_rules2"
    source_addresses = [
      "*",
    ]
    target_fqdns = [
      "security.ubuntu.com",
      "azure.archive.ubuntu.com",
      "changelogs.ubuntu.com"
    ]
    protocol {
      port = "80"
      type = "Http"
    }
  }
  # rule {
  #   name = "gpu_support_rules"
  #   source_addresses = [
  #     "*",
  #   ]
  #   target_fqdns = [
  #     "nvidia.github.io",
  #     "us.download.nvidia.com",
  #     "apt.dockerproject.org",
  #   ]

  #   protocol {
  #     port = "443"
  #     type = "Https"
  #   }
  # }
}

resource "azurerm_firewall_network_rule_collection" "netruleazfw-ports" {
  depends_on = [
    null_resource.dependency_getter,
  ]
  name                = "AzureFirewallNetCollection-ports"
  azure_firewall_name = azurerm_firewall.hubazfw.name
  resource_group_name = var.HUB_RG_NAME
  priority            = 200
  action              = "Allow"
  rule {
    name = "AllowTCPOutbound"
    source_addresses = [
      "*",
    ]
    destination_ports = [
      "9000",
      "22"
    ] #TCP Port used by TunnelFront

    destination_addresses = [
      "*",
    ]
    protocols = [
      "TCP",
    ]
  }
  rule {
    name = "AllowUDPOutbound"
    source_addresses = [
      "*",
    ]
    destination_ports = [
      "53",  #Port used for DNS
      "123", #UDP port used for time services
      "1194" #UDP for Tunnel
    ]

    destination_addresses = [
      "*",
    ]
    protocols = [
      "UDP",
    ]
  }
}

output "azfw_name" {
  value = azurerm_firewall.hubazfw.name
}

output "azfw_PrivIP" {
  value = azurerm_firewall.hubazfw.ip_configuration.0.private_ip_address
}

resource "azurerm_log_analytics_workspace" "azfwlogs" {
  depends_on = [
    null_resource.dependency_getter,
  ]
  name                = "hubazfw-logs${random_integer.uuid.result}"
  location            = var.REGION
  resource_group_name = var.HUB_RG_NAME
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "azfwlogs" {
  depends_on = [
    null_resource.dependency_getter,
  ]
  name                       = "azfw${random_integer.uuid.result}-debug_logs"
  target_resource_id         = azurerm_firewall.hubazfw.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.azfwlogs.id

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

}

resource "null_resource" "dependency_setter" {
  depends_on = [
    azurerm_firewall_network_rule_collection.netruleazfw-ports,
    azurerm_firewall_application_rule_collection.appruleazfw,
    azurerm_monitor_diagnostic_setting.azfwlogs
  ]
}

output "depended_on" {
  value = "${null_resource.dependency_setter.id}-${timestamp()}"
}