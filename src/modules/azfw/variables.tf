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

variable "HUB_SUBNET_ID" {
  type = string
}
/*
* AZFW
*/
variable "DOCKER_REGISTRY" {
  type = string
}

variable "DEPENDENCY" {
  type        = list
  description = ""
}