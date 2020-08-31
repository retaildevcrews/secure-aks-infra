resource azurerm_kubernetes_cluster main {
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
      api_server_authorized_ip_ranges,
      kubernetes_version
    ]
  }
  name                = var.CLUSTER_ID
  location            = var.REGION
  resource_group_name = var.AKS_RG_NAME
  dns_prefix          = var.CLUSTER_ID
  kubernetes_version  = var.K8S_VER

  tags = {
    costcenter           = var.COST_CENTER
    deploymenttype       = var.DEPLOY_TYPE
    environmentinfo      = var.ENVIRONMENT
    notificationdistlist = var.NOTIFY_LIST
    ownerinfo            = var.OWNER_INFO
    platform             = var.PLATFORM
    sponsorinfo          = var.SPONSOR_INFO
  }

  linux_profile {
    admin_username = var.ADMIN_USER

    ssh_key {
      key_data = var.AKS_SSH_ADMIN_KEY
    }
  }

  default_node_pool {
    name                = var.DEF_POOL_NAME
    node_count          = var.DEF_POOL_MIN
    enable_auto_scaling = var.ENABLE_CA_DEF_POOL
    min_count           = var.DEF_POOL_MIN
    max_count           = var.DEF_POOL_MAX
    vm_size             = var.DEF_POOL_NODE_SIZE
    os_disk_size_gb     = var.DEF_POOL_OS_DISK
    vnet_subnet_id      = var.AKS_SUBNET_ID
  }

  private_cluster_enabled = true
  #private_link_enabled    = true
  
  network_profile {
    network_plugin     = "kubenet"
    network_policy     = "calico"
    outbound_type      = "userDefinedRouting"
    service_cidr       = var.SERVICE_CIDR
    dns_service_ip     = var.DNS_IP
    docker_bridge_cidr = var.DOCKER_CIDR
    pod_cidr           = var.POD_CIDR
  }

  role_based_access_control {
    enabled = true
    # azure_active_directory {
    #   # NOTE: in a Production environment these should be different values
    #   # but for the purposes of this example, this should be sufficient
    #   client_app_id = var.AAD_CLIENTAPP_ID

    #   server_app_id     = var.AAD_SERVERAPP_ID
    #   server_app_secret = var.AAD_SERVERAPP_SECRET
    # }
  }

  #USE ONLY IF USING PRE_CREATED SERVICE PRINCIPAL
  service_principal {
    client_id     = var.K8S_SP_CLIENT_ID
    client_secret = var.K8S_SP_CLIENT_SECRET
  }

  #USE ONLY OF USING TF CREATED SERVICE PRINCIPAL
  # service_principal {
  #     client_id     = azuread_service_principal.akssp.application_id
  #     client_secret = azuread_service_principal_password.akssp.value
  #   }

}

output "api_fqdn" {
  value       = azurerm_kubernetes_cluster.main.fqdn
  description = "The FQDN of the Azure Kubernetes Managed Cluster"
}

output "aks_id" {
  value       = azurerm_kubernetes_cluster.main.id
  description = "The FQDN of the Azure Kubernetes Managed Cluster"
}

