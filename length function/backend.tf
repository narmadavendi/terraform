terraform {
  backend "azurerm" {
    count = "${terraform.workspace == "uat" ? 1 :0 }"
    resource_group_name = "uk_resource"
    storage_account_name = "abcdefgh12345storage"
    container_name = "uk-container"
    
  }
}