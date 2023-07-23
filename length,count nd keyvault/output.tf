
output "vnet" {
  value = azurerm_virtual_network.vnet.id
}
output "subnet_web" {
  value = azurerm_subnet.subnets[0].name
  

}
output "subnet_app" {
  value = azurerm_subnet.subnets[1].name
}