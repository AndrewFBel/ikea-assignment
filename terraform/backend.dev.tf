terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
    }
  }

  backend "azurerm" {
    resource_group_name   = "terraform-state"
    storage_account_name  = "andrewbelstorageacc"
    container_name        = "tf-state"
    key                   = "terraform.dev.tfstate"
    use_oidc              = true
  }
}