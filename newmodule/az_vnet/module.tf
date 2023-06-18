resource "azurerm_resource_group" "azresource" {
    name = var.azres.name
    location = var.azres.location
    tags = {
        "env" = "dev"
    }
}
resource "azurerm_virtual_network" "vnet" {
    name = var.vnet.name
    resource_group_name = var.azres.name
    location = var.azres.location
    address_space = var.vnet.address_space
    tags = {
      "env" = "dev"
    }
    depends_on = [ azurerm_resource_group.azresource ]
  
}
resource "azurerm_subnet" "subnets" {
    name = var.subnets
    resource_group_name = var.azres.name
    virtual_network_name = var.vnet.name
    address_prefixes = var.vnet.address_space
    depends_on = [ azurerm_resource_group.azresource,
    azurerm_virtual_network.vnet ]
}
resource "azurerm_public_ip" "name" {
    name = var.pubip.name
    resource_group_name = var.azres.name
    location = var.azres.location
    allocation_method = var.pubip.allocation_method
    depends_on = [ azurerm_resource_group.azresource ]
    tags = {
      "env" = "dev"
    }
}
resource "azurerm_network_interface" "nic" {
    name = var.nic
    resource_group_name = var.azres.name
    location = var.azres.location
    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnets.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.name.id
    }
    tags = {
      "env" = "dev"
    }
    depends_on = [ azurerm_resource_group.azresource ]  
  
}
resource "azurerm_linux_virtual_machine" "vm" {
    name = var.vm
    resource_group_name = var.azres.name
    location = var.azres.location
    size = "Standard_B1s"
    admin_username = "narmadavendi"
    network_interface_ids = [azurerm_network_interface.nic.id,]

    admin_ssh_key {
        username = "narmadavendi"
        public_key = file("~/.ssh/id_rsa.pub")
    }
    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    source_image_reference {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "18.04-LTS"
      version = "latest"
    }
    depends_on = [azurerm_resource_group.azresource]
}