output "vnet" {
    value = azurerm_virtual_network.vnet.id
  
}
output "gh_resource" {
    value = azurerm_resource_group.gh-rg.id
}
  
