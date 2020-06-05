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
 * VNET
 */

variable "AKS_RG_NAME" {
  type = string
}

variable "AKS_VNET_NAME" {
  type        = string
  description = "The name of the virtual network to create."
}

variable "AKS_VNET_CIDR" {
  type        = list
  description = "The name of the virtual network to create."
}

variable "AKS_SUBNET_NAMES" {
  description = "A map of public subnets inside the vNet subnetName=subnetcidr should be the pattern used."
  type        = map
}

variable "DNS_SERVERS" {
  type        = list
  description = ""
}

variable "DEPENDENCY" {
  type        = list
  description = ""
}