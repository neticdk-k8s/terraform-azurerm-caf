resource "azurecaf_name" "acr" {
  name          = var.name
  resource_type = "azurerm_container_registry"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_container_registry" "acr" {
  name                = azurecaf_name.acr.result
  resource_group_name = local.resource_group_name
  location            = local.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  tags                = local.tags

  public_network_access_enabled = var.public_network_access_enabled

  network_rule_set = length(try(var.network_rule_set, {})) == 0 ? null : [
    for k, rule_set in var.network_rule_set : {
      default_action = try(rule_set.default_action, "Allow")
      ip_rule = [
        for ip_rule in values(try(rule_set.ip_rules, {})) : {
          action   = "Allow"
          ip_range = ip_rule.ip_range
        }
      ]
    }
  ]

  dynamic "georeplications" {
    for_each = try(var.georeplications, {})

    content {
      location                        = var.global_settings.regions[georeplications.key]
      tags                            = try(georeplications.value.tags)
      global_endpoint_routing_enabled = try(georeplications.value.global_endpoint_routing_enabled, true)
    }
  }
}

