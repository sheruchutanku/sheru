terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.40.0"
    }
   helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13.0"
    }
    random = {
      source  = "hashicorp/random"  # ✅ Explicit source added
      version = ">= 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.34.0"
    }
  }
backend "azurerm" {
  }
}


provider "azurerm" {
  features {}
#  alias = "oidc"
  use_oidc = true
  use_cli   = false
}


provider "helm" {
  alias                  = "aks1"
kubernetes {
    host                   = azurerm_kubernetes_cluster.aks_cluster1.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster1.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster1.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster1.kube_config.0.cluster_ca_certificate)
  }
}
provider "kubernetes" {
   alias                  = "aks1"
    host                   = azurerm_kubernetes_cluster.aks_cluster1.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster1.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster1.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster1.kube_config.0.cluster_ca_certificate)
  }


provider "helm" {
  alias                  = "aks2"
kubernetes {
    host                   = azurerm_kubernetes_cluster.aks_cluster2.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster2.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster2.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster2.kube_config.0.cluster_ca_certificate)
  }
}
provider "kubernetes" {
    alias                  = "aks2"
    host                   = azurerm_kubernetes_cluster.aks_cluster2.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster2.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster2.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster2.kube_config.0.cluster_ca_certificate)
  }


