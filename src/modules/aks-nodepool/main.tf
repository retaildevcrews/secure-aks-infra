resource "null_resource" "dependency_getter" {
  triggers = {
    my_dependencies = "${join(",", var.DEPENDENCY)}"
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "main" {
  for_each = var.NODEPOOL_DEFS
  depends_on = [
    null_resource.dependency_getter,
  ]
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  kubernetes_cluster_id = var.AKS_ID
  name                  = each.value["name"]
  node_count            = each.value["node_count"]
  enable_auto_scaling   = each.value["enable_autoscale"]
  min_count             = each.value["min_count"]
  max_count             = each.value["max_count"]
  vm_size               = each.value["vm_size"]
  os_disk_size_gb       = each.value["node_disk_size"]
  vnet_subnet_id        = var.AKS_SUBNET_ID
  os_type               = "Linux"
}

resource "null_resource" "dependency_setter" {
  depends_on = [
    azurerm_kubernetes_cluster_node_pool.main
  ]
}

output "depended_on" {
  value = "${null_resource.dependency_setter.id}-${timestamp()}"
}