terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.59.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features{}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name = "rg-terraform-demo"
  location = "Australia East"

  tags = {
    environment = "learning"
    project = "terraform-azure-demo"
    owner = "jack"
    cost-center = "personal-lab"
  }

}

# Create a vnet with a single address space and 2 subnets 

resource "azurerm_virtual_network" "vnet" {
  name = "Terraform-Demo-vnet"
  location = "Australia East"
  resource_group_name = "rg-terraform-demo"
  address_space = ["10.0.0.0/16"]

  subnet {
    name = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name = "subnet2"
    address_prefixes = ["10.0.2.0/24"]
  }

# Create a NSG within the vNET to allow RDP on port 3389

resource "azurerm_network_security_group" "nsg" {
    name = "tf-learning-nsg"
    location = "Australia East"
    resource_group_name = "rg_terraform_demo"

  security_rule {
    name = "allow-rdp"
    priority = "1000"
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3389"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
 }

# Associate the above Network Security Group with subnet1

resource "azure_subnet_network_security_group_association" "subnet1_assoc" {
  subnet_id = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
  
tags = {
    environment = "learning"
    project = "terraform-azure-demo"
  }
}
