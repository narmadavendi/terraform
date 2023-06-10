resource "azurerm_storage_container" "container" {
    name = var.container
    storage_account_name = "abcdefgh12345storage"
    container_access_type = "private"
  
}