resource "azurerm_mssql_server" "uv_sqlserver" {
    count = "${ terraform.workspace == "qa" ? 1 :0 }"
    name = var.sqlserver
    resource_group_name = var.resource.name
    location = var.resource.location
    version = "12.0"
    administrator_login = "tom23-jerry"
    administrator_login_password = "Narmada1234$"
    tags = {
        "env" = "qa"
    }
    depends_on = [ azurerm_resource_group.uvresource ]
   
}
resource "azurerm_mssql_database" "uv_sqldatabase" {
    count = "${ terraform.workspace == "qa" ? 1 :0 }"
    name = var.sqldatabase
    server_id = azurerm_mssql_server.uv_sqlserver[count.index].id
    tags = {
      "env" = "qa"
    }
    depends_on = [ azurerm_mssql_server.uv_sqlserver ]
}
  