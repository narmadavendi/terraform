resource "azurerm_mssql_server" "tom-server" {
  name                         = "tomserver1245"
  resource_group_name          = azurerm_resource_group.cdresource.name
  location                     = azurerm_resource_group.cdresource.location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.username.value
  administrator_login_password = data.azurerm_key_vault_secret.vm-password.value
  tags = {
    "env" = "uat"
  }
  depends_on = [azurerm_resource_group.cdresource]
}
resource "azurerm_mssql_database" "tom-data" {
  name      = "tomdata"
  server_id = azurerm_mssql_server.tom-server.id
  tags = {
    "env" = "uat"
  }
  depends_on = [azurerm_resource_group.cdresource]
}
data "azurerm_key_vault" "narmada" {
  name                = "key5033"
  resource_group_name = "tomcat"
}
data "azurerm_key_vault_secret" "username" {
  name         = "sqlserver-username"
  key_vault_id = data.azurerm_key_vault.narmada.id

}
data "azurerm_key_vault_secret" "vm-password" {
  name         = "sql-password"
  key_vault_id = data.azurerm_key_vault.narmada.id
}
# admin_username = data.azurerm_key_vault_secret.username.value
# admin_password = data.azurerm_key_vault_secret.vm-password.value