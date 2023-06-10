resource "azurerm_mssql_server" "uksql" {
    count = "${terraform.workspace == "uat" ? 1 :0 }"
    name = var.mssql.name
    resource_group_name = var.resource.name
    location = var.resource.location
    version = "12.0"
    administrator_login = "narmadavendi123"
    administrator_login_password = "Narmada398"
    depends_on = [ azurerm_resource_group.ukresource ]
}
resource "azurerm_mssql_database" "ukdatabase" {
    count = "${terraform.workspace == "uat" ? 1 :0 }"
    name = var.database.name
    server_id = azurerm_mssql_server.uksql[count.index].id
    depends_on = [ 
        azurerm_mssql_server.uksql
     ]
  
}