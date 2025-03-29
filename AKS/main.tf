resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}


resource "azurerm_role_definition" "custom_role" {
  name        = "TerraformCustomRole"
  scope       = "/subscriptions/cc4943da-0e1e-4a3c-8305-73a1dfbdd792"
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
    "/subscriptions/cc4943da-0e1e-4a3c-8305-73a1dfbdd792"
  ]
}

resource "azurerm_user_assigned_identity" "example_identity" {
  name                = "example-identity"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

