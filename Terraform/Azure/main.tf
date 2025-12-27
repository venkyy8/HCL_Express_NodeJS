# Terraform script to provision AKS Cluster (1.RG 2.Virtual Network 3.SubNet 4.AKS Cluster)

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "aks_rg" {
  name     = "rg-aks-demo"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "vnet-aks-demo"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

# Subnet
resource "azurerm_subnet" "aks_subnet" {
  name                 = "snet-aks-demo"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-demo-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aksdemodns"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2as_v4"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    dns_service_ip    = "10.2.0.10"
    service_cidr      = "10.2.0.0/24"
  }
}

# Outputs

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

