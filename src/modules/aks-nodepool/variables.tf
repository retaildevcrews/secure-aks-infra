variable "NODEPOOL_DEFS" {
  type = map(object({
    name             = string
    node_count       = string
    enable_autoscale = bool
    min_count        = string
    max_count        = string
    vm_size          = string
    node_disk_size   = string
  }))
  description = ""
}

variable "AKS_SUBNET_ID" {
  type        = string
  description = ""
}

variable "AKS_ID" {
  type        = string
  description = ""
}

variable "DEPENDENCY" {
  type        = list
  description = ""
}