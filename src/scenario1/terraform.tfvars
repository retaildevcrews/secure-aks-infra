CLUSTER_ID          = "badegress"
COST_CENTER         = "RC8765"
DEPLOY_TYPE         = "AKS_WCNP"
ENVIRONMENT         = "PROD"
NOTIFY_LIST         = "mngrs@microsoft.com"
OWNER_INFO          = "tstgrp"
PLATFORM            = "azk8s"
SPONSOR_INFO        = "BizDev"
REGION              = "centralus"
HUB_VNET_ADDR_SPACE = ["192.168.0.0/24"]
HUB_SUBNET_NAMES = {
  AzureFirewallSubnet = "192.168.0.0/26"
}
DOCKER_REGISTRY = "ejvlab.azurecr.io"
AKS_VNET_NAME   = "aks-vnet-centralus-001"
AKS_VNET_CIDR   = ["172.20.0.0/16"]
AKS_SUBNET_NAMES = {
  aks-subnet = "172.20.0.0/21"
}
ADMIN_USER = "ejvuser"
K8S_VER    = "1.16.7"
# AAD_CLIENTAPP_ID="<APPID_FOR_AAD_CLIENT_SP>"
# AAD_SERVERAPP_ID="<APPID_FOR_AAD_SERVER_SP>"
# AAD_SERVERAPP_SECRET="<APPID_SECRET_FOR_AAD_SP>"
AUTH_IP_RANGES     = "100.100.0.0/14,72.183.132.114/32,184.185.0.0/16"
POD_CIDR           = "172.18.0.0/16"
SERVICE_CIDR       = "172.16.0.0/16"
DNS_IP             = "172.16.0.10"
DOCKER_CIDR        = "172.17.0.1/16"
DEF_POOL_NODE_SIZE = "Standard_D2s_v3"
DEF_POOL_OS_DISK   = "128"
DEF_POOL_NAME      = "istiopool"
DEF_POOL_MIN       = "1"
DEF_POOL_MAX       = "5"
ENABLE_CA_DEF_POOL = "true"
NODEPOOL_DEFS = {
  nodepool1 = {
    name             = "workerpool"
    node_count       = "3"
    enable_autoscale = true
    min_count        = "3"
    max_count        = "5"
    vm_size          = "Standard_D2s_v3"
    node_disk_size   = "128"
  },
  nodepool2 = {
    name             = "coreinfpool"
    node_count       = "3"
    enable_autoscale = true
    min_count        = "3"
    max_count        = "5"
    vm_size          = "Standard_D2s_v3"
    node_disk_size   = "128"
  }
}