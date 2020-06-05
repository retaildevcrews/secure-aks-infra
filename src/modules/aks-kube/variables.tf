/*
 * Common
 */
variable "REGION" {
}

variable "CLUSTER_ID" {
}

variable "COST_CENTER" {
  description = "Cost center #"
}

variable "DEPLOY_TYPE" {
  description = "Deployment type for tags"
}

variable "ENVIRONMENT" {
  description = "Environment info"
}

variable "NOTIFY_LIST" {
  description = "notification list"
}

variable "OWNER_INFO" {
}

variable "PLATFORM" {
}

variable "SPONSOR_INFO" {
}
/*
* AKS
*/
variable "AKS_RG_NAME" {
  type        = string
  description = ""
}

variable "K8S_VER" {
  type        = string
  description = ""
}

variable "ADMIN_USER" {
  type        = string
  description = ""
}

variable "AKS_SSH_ADMIN_KEY" {
  type        = string
  description = ""
}

variable "SERVICE_CIDR" {
  description = "Used to assign internal services in the AKS cluster an IP address. This IP address range should be an address space that isn't in use elsewhere in your network environment. This includes any on-premises network ranges if you connect, or plan to connect, your Azure virtual networks using Express Route or a Site-to-Site VPN connections."
  type        = string
}
variable "DNS_IP" {
  description = "should be the .10 address of your service IP address range"
  type        = string
}
variable "DOCKER_CIDR" {
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Default of 172.17.0.1/16."
}

variable "POD_CIDR" {
  description = "IP address (in CIDR notation) used as the POD IP address on nodes. CIDR must be large enough to be spliot in /24 by each node in cluster. This IP address range should be an address space that isn't in use elsewhere in your network environment. This includes any on-premises network ranges if you connect, or plan to connect, your Azure virtual networks using Express Route or a Site-to-Site VPN connections."
}

# variable "AAD_CLIENTAPP_ID" {
#   type = string
# }

# variable "AAD_SERVERAPP_ID" {
#   type = string
# }

# variable "AAD_SERVERAPP_SECRET" {
#   type = string
# }

variable "AUTH_IP_RANGES" {
  type = string
}

variable "ENABLE_CA_DEF_POOL" {
  type = string
}

variable "DEF_POOL_NODE_SIZE" {
  type = string
}

variable "DEF_POOL_NAME" {
  type = string
}

variable "DEF_POOL_OS_DISK" {
  type        = string
  description = ""
}

variable "DEF_POOL_MIN" {
  type = string
}

variable "DEF_POOL_MAX" {
  type = string
}

variable "K8S_SP_CLIENT_ID" {
  type = string
}

variable "K8S_SP_CLIENT_SECRET" {
  type = string
}

variable "AKS_SUBNET_ID" {
  type        = string
  description = ""
}

variable "AZFW_PIP" {
  type        = string
  description = ""
}

variable "DEPENDENCY" {
  type        = list
  description = ""
}