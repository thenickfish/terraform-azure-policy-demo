provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.0.0"
  features {}
}

resource "azurerm_resource_group" "prod_resource_group" {
  name     = "azure-policy-demo-prod"
  location = "West US"
}

module "policy" {
  source            = "../modules/policy"
  vm_name_pattern   = "prod-####"
  resource_group_id = azurerm_resource_group.prod_resource_group.id
}
