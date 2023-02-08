# choose a for resource group
variable "name" {
  type = string
  default = "istio"
}


# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = "chinanorth3"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["172.16.0.0/16"]
}

resource "azurerm_subnet" "aks" {
  name                 = "sn-aks"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["172.16.1.0/24"]
}

resource "azurerm_subnet" "client" {
  name                 = "sn-client"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["172.16.2.0/24"]
}

resource "azurerm_subnet" "natgw" {
  name                 = "sn-natgw"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["172.16.3.0/24"]
}

# Create NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allowport"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "sn-client" {
  subnet_id                 = azurerm_subnet.client.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
