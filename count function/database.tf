resource "azurerm_mssql_server" "sqlserver" {
  count = "${ terraform.workspace == "dev" ? 1:0 }"  
  name                         = var.sqlserver.name
  resource_group_name          = var.resource.name
  location                     = var.resource.location
  version                      = var.sqlserver.version
  administrator_login          = var.sqlserver.administrate_login
  administrator_login_password = var.sqlserver.administrate_login_password
  tags = {
    "env" = var.sqlserver.tags
  }
  depends_on = [azurerm_resource_group.usresource]
}
resource "azurerm_mssql_database" "sqldatabase" {
  count = "${ terraform.workspace == "dev" ? 1:0 }"  
  name      = var.database.name
  server_id = azurerm_mssql_server.sqlserver[count.index].id
  tags = {
    "env" = var.database.tags
  }
  depends_on = [azurerm_mssql_server.sqlserver]

}      