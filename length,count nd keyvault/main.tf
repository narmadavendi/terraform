resource "azurerm_resource_group" "cdresource" {
  name     = "vendi-resource"
  location = "West Us"
  tags = {
    "env" = "uat"
  }
}
resource "azurerm_virtual_network" "vnet" {
  name                = "cd_vnet"
  resource_group_name = azurerm_resource_group.cdresource.name
  location            = azurerm_resource_group.cdresource.location
  address_space       = ["10.0.0.0/16"]
  tags = {
    "env" = "uat"
  }
  depends_on = [azurerm_resource_group.cdresource]
}
resource "azurerm_subnet" "subnets" {
  count                = 3
  name                 = var.subnets[count.index]
  resource_group_name  = azurerm_resource_group.cdresource.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet("10.0.0.0/16", 8, count.index)]
  depends_on           = [azurerm_virtual_network.vnet]
}
resource "azurerm_public_ip" "pubip" {
  count               = 3
  name                = var.pubip.name[count.index]
  resource_group_name = azurerm_resource_group.cdresource.name
  location            = azurerm_resource_group.cdresource.location
  allocation_method   = var.pubip.allocation_method
  tags = {
    "env" = "uat"
  }
  depends_on = [azurerm_resource_group.cdresource]
}
resource "azurerm_network_interface" "nic" {
  count               = length(var.nic)
  name                = var.nic[count.index]
  location            = azurerm_resource_group.cdresource.location
  resource_group_name = azurerm_resource_group.cdresource.name
  ip_configuration {
    name                          = var.nic[count.index]
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip[count.index].id
  }
  depends_on = [azurerm_virtual_network.vnet,
  azurerm_subnet.subnets]
}
resource "azurerm_linux_virtual_machine" "vms" {
  count               = length(var.vms)
  name                = var.vms[count.index]
  resource_group_name = azurerm_resource_group.cdresource.name
  location            = azurerm_resource_group.cdresource.location
  size                = "Standard_B1s"
  admin_username      = "narmadavendi"
  network_interface_ids = [azurerm_network_interface.nic[count.index].id,
  ]

  admin_ssh_key {
    username   = "narmadavendi"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  depends_on = [azurerm_resource_group.cdresource]

}