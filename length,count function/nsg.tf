resource "azurerm_network_security_group" "nsg" {
    name = "nsg-rg"
    resource_group_name = azurerm_resource_group.cdresource.name
    location = azurerm_resource_group.cdresource.location
}
resource "azurerm_network_security_rule" "nsg1" {
    name = "nsgrl"
    resource_group_name = azurerm_resource_group.cdresource.name
    network_security_group_name = azurerm_network_security_group.nsg.name
    direction = "Inbound"
    priority = "300"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
}
resource "azurerm_network_security_rule" "nsg2" {
    name = "nsgr2"
    resource_group_name = azurerm_resource_group.cdresource.name
    network_security_group_name = azurerm_network_security_group.nsg.name
    direction = "Inbound"
    priority = "320"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
}
resource "azurerm_network_security_rule" "nsg3" {
    name = "nsgr3"
    resource_group_name = azurerm_resource_group.cdresource.name
    network_security_group_name = azurerm_network_security_group.nsg.name
    direction = "Inbound"
    priority = "200"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
}
resource "azurerm_network_interface_security_group_association" "nsg5" {
    count = length(var.nic)
    network_interface_id = azurerm_network_interface.nic[count.index].id
    network_security_group_id = azurerm_network_security_group.nsg.id
  
}