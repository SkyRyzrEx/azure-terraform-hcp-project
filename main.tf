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

  tags = {
    environment = "learning"
    project = "terraform-azure-demo"
  }
}
