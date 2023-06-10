resource "azurerm_storage_account" "tustorage" {
  count = "${ terraform.workspace == "dev" ? 1:0 }"  
  name                     = var.storage.name
  resource_group_name      = var.resource.name
  location                 = var.resource.location
  account_tier             = var.storage.account_tier
  account_replication_type = var.storage.account_replication_type
  tags = {
    "env" = var.storage.tags
  }
  depends_on = [azurerm_resource_group.usresource]


}