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
}

provider "azurerm" {
  features {}
#   subscription_id = "d184e3f5-97a5-4b27-a0b8-51d1761d16e5"
#   tenant_id       = "d670199b-8556-4841-9061-b0310ae108c7"
}
