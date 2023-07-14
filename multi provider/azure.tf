resource "azurerm_resource_group" "rg" {
    name = "rg-resource"
    location = "East Us"
    tags = {
      "env" = "dev"

    }
}
resource "azurerm_virtual_network" "rg-vnet" {
    name = "rg_vnet"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space = ["10.0.0.0/16"]
    tags = {
      "env" = "dev"
    }
    depends_on = [ azurerm_resource_group.rg ]
}
resource "azurerm_subnet" "rgsub" {
  name = "rg-sub"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.rg-vnet.name
  address_prefixes = ["10.0.1.0/24"]

  depends_on = [ azurerm_virtual_network.rg-vnet ]
  
}
resource "azurerm_public_ip" "rg-pub" {
  name = "rg_pub"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = "Static"
  tags = {
    "env" = "dev"
  }
}