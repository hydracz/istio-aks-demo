resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-${var.name}"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2s_v5"
    vnet_subnet_id  = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }
 
  linux_profile {
    admin_username = "azuser"
    ssh_key {
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }
}

resource "azurerm_role_assignment" "contributor" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity.0.principal_id
}


resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.aks]
  filename     = "./kubeconfig"
  content      = azurerm_kubernetes_cluster.aks.kube_config_raw
}
