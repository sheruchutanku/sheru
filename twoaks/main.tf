locals {
  env                 = "dev"
  region              = "eastus2"
  resource_group_name1 = "tutorial1"
  resource_group_name2 = "tutorial2"
  eks_name            = "demo"
  eks_version         = "1.27"
}

resource "azurerm_resource_group" "aks1" {
  name     = local.resource_group_name1
  location = local.region
}



resource "azurerm_kubernetes_cluster" "aks_cluster1" {
  name                = "aks1"
  location            = azurerm_resource_group.aks1.location
  resource_group_name = azurerm_resource_group.aks1.name
  dns_prefix          = "aksdns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

   key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin = "azure"
  }

}

resource "azurerm_resource_group" "aks2" {
  name     = local.resource_group_name2
  location = local.region
}

resource "azurerm_kubernetes_cluster" "aks_cluster2" {
  name                = "aks2"
  location            = azurerm_resource_group.aks2.location
  resource_group_name = azurerm_resource_group.aks2.name
  dns_prefix          = "aksdns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

   key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin = "azure"
  }

}


resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
#  version    = "1.41.3"
  create_namespace = true
  provider = helm.aks1
  depends_on = [azurerm_kubernetes_cluster.aks_cluster1,azurerm_kubernetes_cluster.aks_cluster2]

}




resource "kubernetes_namespace" "ns_aks1" {
  provider = kubernetes.aks1
  metadata {
    name = "myapp1"
  }
  depends_on = [azurerm_kubernetes_cluster.aks_cluster1]
}

resource "kubernetes_namespace" "ns_aks2" {
  provider = kubernetes.aks2
  metadata {
    name = "myapp2"
  }
  depends_on = [azurerm_kubernetes_cluster.aks_cluster2]
}

