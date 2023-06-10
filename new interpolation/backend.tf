terraform {
  backend "azurerm" {
    resource_group_name = "uv_resource"
    storage_account_name = "abcstorageaccountname"
    container_name = "lillycontainer"
    key = "Lilly123@"
  }
}