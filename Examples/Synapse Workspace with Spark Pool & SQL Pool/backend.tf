# Backend Configuration Using Azure Stroage Account

terraform {
  backend "azurerm" {
    resource_group_name  = "example-tf-rg"
    storage_account_name = "storage1234"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}