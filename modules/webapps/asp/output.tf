output "id" {
  value = azurerm_service_plan.asp.id
}

output "maximum_number_of_workers" {
  value = azurerm_service_plan.asp.worker_count
}

output "ase_id" {
  value = var.app_service_environment_id
}