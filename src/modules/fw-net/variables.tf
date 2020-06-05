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

variable "HUB_RG_NAME" {
  type = string
}

variable "HUB_VNET_ADDR_SPACE" {
  type        = list
  description = "The address space that is used by the virtual network."
}

variable "HUB_SUBNET_NAMES" {
  description = "A map of public subnets inside the vNet subnetName=subnetcidr should be the pattern used."
  type        = map
}

variable "DEPENDENCY" {
  type        = list
  description = ""
}