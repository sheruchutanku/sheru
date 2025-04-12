resource "azurerm_resource_group" "example_oidc" {
  name     = "example-oidc"
  location = "East US"

  provider = azurerm.oidc
}

resource "azurerm_resource_group" "example_msi" {
  name     = "example-msi"
  location = "East US"

  provider = azurerm.msi
}  

