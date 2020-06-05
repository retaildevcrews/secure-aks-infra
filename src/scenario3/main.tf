provider "azurerm" {
  features {}

  subscription_id = var.SUB_ID
  client_id       = var.TFUSER_CLIENT_ID
  client_secret   = var.TFUSER_CLIENT_SECRET
  tenant_id       = var.TENANT_ID
}

data "azurerm_resource_group" "exist-rg" {
  name = var.RG_TO_DEPLOY_TO
}
module "exist-vnet" {
  source = "../modules/exist-vnet"

  EXISTING_VNET_NAME   = var.EXISTING_VNET_NAME
  EXISTING_VNET_RG     = var.EXISTING_VNET_RG
  EXISTING_SUBNET_NAME = var.EXISTING_SUBNET_NAME
}

module "aks-kube-pvl" {
  source = "../modules/aks-kube-pvl"

  AKS_RG_NAME          = var.RG_TO_DEPLOY_TO
  AKS_SUBNET_ID        = module.exist-vnet.subnet_id
  K8S_VER              = var.K8S_VER
  ADMIN_USER           = var.ADMIN_USER
  AKS_SSH_ADMIN_KEY    = var.AKS_SSH_ADMIN_KEY
  SERVICE_CIDR         = var.SERVICE_CIDR
  DNS_IP               = var.DNS_IP
  DOCKER_CIDR          = var.DOCKER_CIDR
  POD_CIDR             = var.POD_CIDR
  AUTH_IP_RANGES       = var.AUTH_IP_RANGES
  ENABLE_CA_DEF_POOL   = var.ENABLE_CA_DEF_POOL
  DEF_POOL_NODE_SIZE   = var.DEF_POOL_NODE_SIZE
  DEF_POOL_NAME        = var.DEF_POOL_NAME
  DEF_POOL_OS_DISK     = var.DEF_POOL_OS_DISK
  DEF_POOL_MIN         = var.DEF_POOL_MIN
  DEF_POOL_MAX         = var.DEF_POOL_MAX
  K8S_SP_CLIENT_ID     = var.K8S_SP_CLIENT_ID
  K8S_SP_CLIENT_SECRET = var.K8S_SP_CLIENT_SECRET
  # AAD_CLIENTAPP_ID = var.AAD_CLIENTAPP_ID
  # AAD_SERVERAPP_ID = var.AAD_SERVERAPP_ID
  # AAD_SERVERAPP_SECRET = var.AAD_SERVERAPP_SECRET
  CLUSTER_ID   = var.CLUSTER_ID
  COST_CENTER  = var.COST_CENTER
  DEPLOY_TYPE  = var.DEPLOY_TYPE
  ENVIRONMENT  = var.ENVIRONMENT
  NOTIFY_LIST  = var.NOTIFY_LIST
  OWNER_INFO   = var.OWNER_INFO
  PLATFORM     = var.PLATFORM
  SPONSOR_INFO = var.SPONSOR_INFO
  REGION       = data.azurerm_resource_group.exist-rg.location
}

module "aks-nodepool" {
  source = "../modules/aks-nodepool"

  AKS_ID        = module.aks-kube-pvl.aks_id
  AKS_SUBNET_ID = module.exist-vnet.subnet_id
  NODEPOOL_DEFS = var.NODEPOOL_DEFS
  DEPENDENCY    = []

}
