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

variable "AZFW_NAME" {
  type = string
}

variable "AKS_SUBNET_ID" {
  type        = string
  description = "The name of the virtual network to create."
}

variable "AKS_RG_NAME" {
  type = string
}

variable "AZFW_PRIV_IP" {
  type        = string
  description = ""
}

variable "DEPENDENCY" {
  type        = list
  description = ""
}