resource "azurerm_sentinel_alert_rule_scheduled" "scheduled" {
  name                       = var.name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  display_name               = var.display_name
  severity                   = var.severity
  query                      = var.query
  alert_rule_template_guid   = var.alert_rule_template_guid
  description                = var.description
  enabled                    = var.enabled
  query_frequency            = var.query_frequency
  query_period               = var.query_period
  suppression_duration       = var.suppression_duration
  suppression_enabled        = var.suppression_enabled
  tactics                    = var.tactics
  trigger_operator           = var.trigger_operator
  trigger_threshold          = var.trigger_threshold

  dynamic "event_grouping" {
    for_each = lookup(var.settings, "event_grouping", {}) != {} ? [1] : []

    content {
      aggregation_method = lookup(var.settings.event_grouping, "aggregation_method", null)
    }
  }

  dynamic "incident" {
    for_each = lookup(var.settings, "incident_configuration", {}) != {} ? [1] : []

    content {
      create_incident_enabled = try(var.settings.incident_configuration.create_incident_enabled, var.settings.incident_configuration.create_incident, true)

      dynamic "grouping" {
        for_each = lookup(var.settings.incident_configuration, "grouping", {}) != {} ? [1] : []

        content {
          enabled                 = lookup(var.settings.incident_configuration.grouping, "enabled", true)
          lookback_duration       = lookup(var.settings.incident_configuration.grouping, "lookback_duration", "PT5M")
          reopen_closed_incidents = lookup(var.settings.incident_configuration.grouping, "reopen_closed_incidents", false)
          entity_matching_method  = lookup(var.settings.incident_configuration.grouping, "entity_matching_method", null)
          by_entities             = lookup(var.settings.incident_configuration.grouping, "group_by_entities", null)
          by_alert_details        = lookup(var.settings.incident_configuration.grouping, "group_by_alert_details", null)
          by_custom_details       = lookup(var.settings.incident_configuration.grouping, "group_by_custom_details", null)
        }
      }
    }
  }
}
