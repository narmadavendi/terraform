resource "azurerm_storage_account" "storage" {
count = "${terraform.workspace == "uat" ? 1 :0 }"    
name = var.storage.name
resource_group_name = var.resource.name
location = var.resource.location
account_tier = "Standard"
account_replication_type = "LRS"
depends_on = [ azurerm_resource_group.ukresource ]
  
}