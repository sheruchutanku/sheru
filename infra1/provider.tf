terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.40.0"
    }
    random = {
      source  = "hashicorp/random"  #
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

#provider "azurerm" {
#  features {}
#   subscription_id = "d184e3f5-97a5-4b27-a0b8-51d1761d16e5"
#   tenant_id       = "d670199b-8556-4841-9061-b0310ae108c7"
#}

provider "azurerm" {
  features {}
#  alias = "oidc"
  use_oidc = true
  use_cli   = false
}
