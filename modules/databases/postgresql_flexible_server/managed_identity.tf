module "managed_identity" {
  source   = "../../security/managed_identity"
  for_each = try(var.managed_identity, {})

  name                = each.value.name
  location            = local.location
  resource_group_name = local.resource_group_name
  global_settings     = var.global_settings
  settings            = each.value
  base_tags           = var.base_tags_msi
  client_config       = var.client_config
}