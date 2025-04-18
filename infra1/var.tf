variable "node_count" {
  default = 1
}

variable "dns_prefix" {
  default = "aks-k8s-2022"
}

variable "cluster_name" {
}

variable "kubernetes_version" {
  default = "1.21.2"
}

variable "acr_name" {
}


variable "resource_group_name" {
}

variable "location" {
  default = "eastus"
}
