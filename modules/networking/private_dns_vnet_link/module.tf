resource "azurecaf_name" "pnetlk" {
  for_each = var.settings.private_dns_zones

  name          = each.value.name
  resource_type = "azurerm_private_dns_zone_virtual_network_link"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_links" {
  for_each = var.settings.private_dns_zones

  name = azurecaf_name.pnetlk[each.key].result
  private_dns_zone_id = can(each.value.private_dns_zone_id) ? each.value.private_dns_zone_id : (
    can(each.value.resource_group_name) && can(each.value.private_dns_zone_name)
    ? "/subscriptions/${var.client_config.subscription_id}/resourceGroups/${each.value.resource_group_name}/providers/Microsoft.Network/privateDnsZones/${each.value.private_dns_zone_name}"
    : var.private_dns[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.key].id
  )
  virtual_network_id   = var.virtual_network_id
  registration_enabled = try(each.value.registration_enabled, false)
  tags                 = merge(var.base_tags, local.module_tag, try(each.value.tags, null))
}