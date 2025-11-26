resource "azurerm_monitor_action_group" "az_monitor" {
  name                = "${var.name}-ag"
  resource_group_name = var.resource_group_name
  short_name          = "AG${var.name}"
  tags                = var.tags

  email_receiver {
    name          = "email-alert"
    email_address = var.email
  }
}

resource "azurerm_monitor_metric_alert" "az_monitoralert" {
  name                = var.name
  resource_group_name = var.resource_group_name
  scopes              = [var.scope]
  severity            = var.severity
  auto_mitigate       = true
  frequency           = var.frequency
  window_size         = var.window_size

  criteria {
    metric_name      = var.metric_name
    metric_namespace = var.metric_namespace
    operator         = var.operator
    threshold        = var.threshold
    aggregation      = var.aggregation_type
  }

  action {
    action_group_id = azurerm_monitor_action_group.az_monitor.id
  }

  tags = var.tags
}
