# configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4"
    }
  }

  required_version = ">= 1.1.0"
}

# configure azurem provider
provider "azurerm" {
  features {}
}

# create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

# create a log analytics workspace
resource "azurerm_log_analytics_workspace" "example" {
  name                = "acctest-01"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# create a container app environment
resource "azurerm_container_app_environment" "example" {
  name                       = "myEnvironment"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
  infrastructure_subnet_id   = var.infrastructure_subnet_id
}

# create a storage account
resource "azurerm_storage_account" "example" {
  name                     = "azureteststorage12345"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# create a file share
resource "azurerm_storage_share" "example" {
  name                 = "sharename"
  storage_account_name = azurerm_storage_account.example.name
  quota                = 5
}

# create a storage accont for ACA environment
resource "azurerm_container_app_environment_storage" "example" {
  name                         = "mycontainerappstorage"
  container_app_environment_id = azurerm_container_app_environment.example.id
  account_name                 = azurerm_storage_account.example.name
  share_name                   = azurerm_storage_share.example.name
  access_key                   = azurerm_storage_account.example.primary_access_key
  access_mode                  = "ReadOnly"
}