terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.59.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ------------------------
# Resource Group
# ------------------------
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-demo"
  location = "Australia East"

  tags = {
    environment = "learning"
    project     = "terraform-azure-demo"
    owner       = "jack"
    cost-center = "personal-lab"
  }
}

# ------------------------
# Virtual Network
# ------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "Terraform-Demo-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "learning"
    project     = "terraform-azure-demo"
  }
}

# ------------------------
# Subnets (separate resources)
# ------------------------
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# ------------------------
# Network Security Group
# ------------------------
resource "azurerm_network_security_group" "nsg" {
  name                = "tf-learning-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-rdp"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "learning"
    project     = "terraform-azure-demo"
  }
}

# ------------------------
# Associate NSG with subnet1
# ------------------------
resource "azurerm_subnet_network_security_group_association" "subnet1_assoc" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
