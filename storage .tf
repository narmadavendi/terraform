resource "azurerm_storage_account" "narmada-storage" {
    name = "narmadastorageaccount"
    resource_group_name = azurerm_resource_group.narmada-resource.name
    location = azurerm_resource_group.narmada-resource.location
    account_tier = "Standard"
    account_replication_type = "GRS"

    tags = {
        "env" = "Dev"
    } 
}