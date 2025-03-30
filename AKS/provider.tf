provider "azurerm" {
  features {}
  use_oidc = true
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.40.0"
    }
    random = {
      version = ">= 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.34.0"
    }
  }

  backend "azurerm" {
    resource_group_name   = "my-backend-rg"
    storage_account_name  = "myterraformstorage"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}


