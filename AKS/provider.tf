provider "azurerm" {
  features {}
#  alias = "oidc"
  use_oidc = true
  use_cli   = false
}

#provider "azurerm" {
#  alias  = "msi"
#  use_msi = true
#  features {}
#}


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
  #  resource_group_name   = "back"
  #  storage_account_name  = "tt420"
  #  container_name        = "tfstate"
  #  key                   = "terraform.tfstate"
  }
}


