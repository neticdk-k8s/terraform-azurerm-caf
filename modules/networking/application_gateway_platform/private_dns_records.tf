
resource "azurerm_private_dns_a_record" "a_records" {
  for_each = try(var.settings.private_dns_records.a_records, {})

  name = each.value.name
  private_dns_zone_id = can(each.value.private_dns_zone_id) ? each.value.private_dns_zone_id : (
    can(each.value.resource_group_name) && can(each.value.zone_name)
    ? "/subscriptions/${var.client_config.subscription_id}/resourceGroups/${each.value.resource_group_name}/providers/Microsoft.Network/privateDnsZones/${each.value.zone_name}"
    : var.private_dns[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.private_dns_key].id
  )
  ttl     = each.value.ttl
  records = [local.private_ip_address]
  tags    = merge(local.tags, try(each.value.tags, {}))
}
