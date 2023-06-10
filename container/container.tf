resource "azurerm_storage_container" "storagecontainer" {
    name = var.container
    storage_account_name = "abcstorageaccountname"
    container_access_type = "private"
}