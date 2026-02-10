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
}
