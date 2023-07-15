resource "azurerm_network_security_group" "ntiernsg" {
  name                = local.name6
  resource_group_name = local.name
  location            = local.location
}
resource "azurerm_network_security_rule" "ntiernsg_rule" {
  name                        = "all"
  resource_group_name         = local.name
  network_security_group_name = local.name6
  priority                    = 320
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"

}
resource "azurerm_network_security_rule" "ntiernsg_rule2" {
  name                        = "all"
  resource_group_name         = local.name
  network_security_group_name = local.name6
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}
resource "azurerm_network_security_rule" "ntiernsg_rule3" {
  name                        = "all"
  resource_group_name         = local.name
  network_security_group_name = local.name6
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}
resource "azurerm_subnet_network_security_group_association" "ntiernsg_assc" {
  count = 3  
  subnet_id                 = azurerm_subnet.subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.ntiernsg.id
}