resource "azurerm_mssql_server" "qtserver" {
    count = var.env == "dev" ? 1 : 0
    name = var.server.name
    resource_group_name = var.resource.name
    location = var.resource.location
    version = var.server.version
    administrator_login = var.server.administrator_login
    administrator_login_password = var.server.administrator_login_password
    tags = {
      "env" = var.env
    }
    depends_on = [ azurerm_resource_group.qa-resource ]
  
}
resource "azurerm_mssql_database" "qtdatabase" {
    count = var.env == "dev" ? 1 : 0
    name = var.database
    server_id = azurerm_mssql_server.qtserver[count.index].id
    tags = {
      "env" = var.env
    }
    depends_on = [ azurerm_mssql_server.qtserver ]
  
}