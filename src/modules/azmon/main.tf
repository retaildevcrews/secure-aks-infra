data "azurerm_log_analytics_workspace" "debuglaw" {
  name                = "${var.LOG_ANALYTICS_WORKSPACE_NAME}"
  resource_group_name = "${var.LOG_ANALYTICS_WORKSPACE_RG}"
}

resource "azurerm_monitor_diagnostic_setting" "azfwlogs" {
  name                       = "azfw_debug_logs"
  target_resource_id         = "${azurerm_firewall.hubazfw.id}"
  log_analytics_workspace_id = "${data.azurerm_log_analytics_workspace.debuglaw.id}"

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

}