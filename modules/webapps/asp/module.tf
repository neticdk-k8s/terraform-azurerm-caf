
resource "azurecaf_name" "plan" {
  name          = var.settings.name
  resource_type = "azurerm_app_service_plan"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}


resource "azurerm_service_plan" "asp" {
  name                         = azurecaf_name.plan.result
  location                     = local.location
  resource_group_name          = local.resource_group_name
  maximum_elastic_worker_count = lookup(var.settings, "maximum_elastic_worker_count", null)

  os_type = try(
    var.settings.os_type,
    lower(try(var.kind, "")) == "linux" || try(var.settings.reserved, false) == true ? "Linux" : (try(var.settings.is_xenon, false) == true ? "WindowsContainer" : "Windows")
  )
  sku_name                 = try(var.settings.sku_name, var.settings.sku.size)
  worker_count             = try(var.settings.worker_count, lookup(var.settings.sku, "capacity", null))
  per_site_scaling_enabled = lookup(var.settings.sku, "per_site_scaling", false)

  app_service_environment_id = var.app_service_environment_id
  zone_balancing_enabled     = try(var.settings.zone_balancing_enabled, lookup(var.settings, "zone_redundant", null))
  tags                       = merge(local.tags, try(var.settings.tags, {}))

  timeouts {
    create = "5h"
    update = "5h"
  }

  lifecycle {
    # TEMP until native tf provider for ASE ready to avoid force replacement of asp on every ase changes
    ignore_changes = [app_service_environment_id]
  }
}


