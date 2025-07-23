resource "azurerm_resource_group" "example" {
  name     = "maa"
  location = "eastus2"
}


resource "azurerm_role_definition" "custom_role" {
  name        = "TerraformCustomRole"
  scope       = "/subscriptions/${var.subscription_id}"
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
    "/subscriptions/${var.subscription_id}"
  ]
}

resource "azurerm_user_assigned_identity" "example_identity" {
  name                = "example-identity"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

