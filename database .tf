resource "azurerm_mssql_server" "narmada-sql" {
  name = "narmada1-sql"
  resource_group_name = azurerm_resource_group.narmada-resource.name
  location = azurerm_resource_group.narmada-resource.location
  version = "12.0"
  administrator_login = "narmadavendi"
  administrator_login_password = "narmada123$"

  tags = {
    "env" = "Dev"
  }  
}
resource "azurerm_mssql_database" "narmada-database" {
  name = "narmada1-database"
  resource_group_name = azurerm_resource_group.narmada-resource.name
  location = azurerm_resource_group.narmada-resource.location
  server_name = azurerm_mssql_server.narmada-sql.name
  tags = {
    "env" = "Dev"
  }  
}