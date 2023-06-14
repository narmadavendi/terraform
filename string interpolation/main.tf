resource "azurerm_resource_group" "uk-resource" {
    name = var.resource.name
    location = var.resource.location
    tags = {
      "env" = var.resource.tags
    }
}
resource "azurerm_virtual_network" "vnet" {
    name = var.vnet.name
    resource_group_name = var.resource.name
    location = var.resource.location
    address_space = var.vnet.address_space
    tags = {
      "env" = var.vnet.tags
    }
    depends_on = [ azurerm_resource_group.uk-resource ]
  
}
resource "azurerm_subnet" "subnets" {
    count = var.vms
    name = "sub-${count.index}"
    resource_group_name = var.resource.name
    virtual_network_name = var.vnet.name
    address_prefixes = [cidrsubnet("192.168.0.0/16",8,count.index)]
    depends_on = [ azurerm_resource_group.uk-resource,
    azurerm_virtual_network.vnet ]

}
resource "azurerm_public_ip" "ukpubip" {
    count = var.vms
    name = "ukpubip-${count.index}"
    resource_group_name = var.resource.name
    location = var.resource.location
    allocation_method = "Static"
    tags = {
        "env" = "qa"
    }
    depends_on = [ azurerm_resource_group.uk-resource ]
  
}
resource "azurerm_network_interface" "uknic" {
    count = var.vms
    name = "uknic-${count.index}"
    location = var.resource.location
    resource_group_name = var.resource.name
    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnets[count.index].id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.ukpubip[count.index].id
    }
    depends_on = [ azurerm_resource_group.uk-resource ]
} 
resource "azurerm_linux_virtual_machine" "vms" {
    count = var.vms
    name = "ukvm-${count.index}"
    resource_group_name = var.resource.name
    location = var.resource.location
    size = "Standard_B1ms"
    admin_username = "uv123"
    network_interface_ids = [
        azurerm_network_interface.uknic[count.index].id,
    ]

    admin_ssh_key {
      username = "uv123"
      public_key = file("~/.ssh/id_rsa.pub")
    }
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference {
      publisher = "Canonical"
      offer =  "0001-com-ubuntu-server-jammy"
      sku = "22_04-lts-gen2"
      version = "latest" 
    }
    
}   