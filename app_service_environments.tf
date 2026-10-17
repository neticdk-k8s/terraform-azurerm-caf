
module "app_service_environments_v3" {
  source = "./modules/webapps/asev3"

  for_each = local.webapp.app_service_environments_v3

  global_settings     = local.global_settings
  settings            = each.value
  subnet_id           = can(each.value.subnet_id) ? each.value.subnet_id : local.combined_objects_networking[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.vnet_key].subnets[each.value.subnet_key].id
  diagnostic_profiles = try(each.value.diagnostic_profiles, {})
  diagnostics         = local.combined_diagnostics
  private_dns         = lookup(each.value, "private_dns_records", null) == null ? {} : local.combined_objects_private_dns

  base_tags           = local.global_settings.inherit_tags
  resource_group      = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)]
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : null
  location            = try(local.global_settings.regions[each.value.region], null)
}

output "app_service_environments_v3" {
  value = module.app_service_environments_v3
}