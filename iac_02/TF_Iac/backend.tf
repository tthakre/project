terraform {
  backend "azurerm" {
    resource_group_name   = "myproject-dev-rg"
    storage_account_name  = "myprojectdevtfstate"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}