terraform {
  backend "azurerm" {
    resource_group_name  = "tf-rg"             # Matches the resource group in main.tf
    storage_account_name = "tfstorage366"      # Matches the storage account name in main.tf
    container_name       = "tfcontainer"       # Matches the storage container in main.tf
    key                  = "terraform.tfstate" # The key for storing the state file
  }
}

