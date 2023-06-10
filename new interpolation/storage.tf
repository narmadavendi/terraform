resource "azurerm_storage_account" "storage" {
    count = "${ terraform.workspace == "qa" ? 1 :0 }"
    name = var.storage
    resource_group_name = var.resource.name
    location = var.resource.location
    account_tier = "Standard"
    account_replication_type = "GRS"
    tags = {
        "env" = "qa"
    }
    depends_on = [azurerm_resource_group.uvresource] 
}