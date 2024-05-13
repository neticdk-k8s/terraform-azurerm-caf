module "managed_identity" {
  source   = "../../security/managed_identity"
  for_each = try(var.managed_identity, {})

  resource_id         = azurerm_postgresql_flexible_server.postgresql.id
  name                = each.value.name
  location            = local.location
  resource_group_name = local.resource_group_name