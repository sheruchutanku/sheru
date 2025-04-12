resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}


resource "azurerm_role_definition" "custom_role" {
  name        = "TerraformCustomRole"
  scope       = "/subscriptions/d184e3f5-97a5-4b27-a0b8-51d1761d16e5"
  description = "Custom role for Terraform with limited permissions"
  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/subscriptions/resourceGroups/write",
      "Microsoft.Compute/*",
      "Microsoft.Network/*",
      "Microsoft.Storage/*"
    ]
    not_actions = []
  }
  assignable_scopes = [
    "/subscriptions/d184e3f5-97a5-4b27-a0b8-51d1761d16e5"
  ]
}

resource "azurerm_user_assigned_identity" "example_identity" {
  name                = "example-identity"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

