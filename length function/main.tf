resource "azurerm_resource_group" "ukresource" {
    count = "${terraform.workspace == "uat" ? 1 :0 }" 
    name = var.resource.name
    location = var.resource.location
    tags = {
        "env" = var.resource.tags
    }

}
resource "azurerm_virtual_network" "vnet" {
    count = "${terraform.workspace == "uat" ? 1 :0 }"
    name = var.vnet.name
    resource_group_name = var.resource.name
    location = var.resource.location
    address_space = var.vnet.address_space
    tags = {
      "env" = var.vnet.tags
    }
    depends_on = [ azurerm_resource_group.ukresource ]
}
resource "azurerm_subnet" "subnets" {
    count = "${terraform.workspace == "uat" ? 3 :0 }"
    name = var.subnets[count.index]
    resource_group_name = var.resource.name
    virtual_network_name = var.vnet.name
    address_prefixes = [cidrsubnet("10.0.0.0/16",8,count.index)] 
    depends_on = [ azurerm_resource_group.ukresource,
                   azurerm_virtual_network.vnet

     ]
}
resource "azurerm_public_ip" "ukpubip" {
    count = "${terraform.workspace == "uat" ? 3 :0 }"
    name = var.pubip[count.index]
    resource_group_name = var.resource.name
    location = var.resource.location
    allocation_method = "Static"
    tags = {
      "env" = "uat"
    }
    depends_on = [ azurerm_resource_group.ukresource ]

  
}
resource "azurerm_network_interface" "uknic" {
    count = "${terraform.workspace == "uat" ? 3 :0 }"
    name = var.nic[count.index] 
    resource_group_name = var.resource.name
    location = var.resource.location
    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnets[count.index].id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.ukpubip[count.index].id
    }
    tags = {
        "env" = "uat"
    }
    depends_on = [ azurerm_subnet.subnets ]
  
}
resource "azurerm_linux_virtual_machine" "ukvms" {
    count = "${terraform.workspace == "uat" ? 3 :0 }"
    name = var.ukvms[count.index]
    resource_group_name = var.resource.name
    location = var.resource.location
    size = "Standard_B1s"
    admin_username = "narmadavendi"
    network_interface_ids = [
        azurerm_network_interface.uknic[count.index].id,
    ]
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
      offer = "0001-com-ubuntu-server-jammy"
      sku = "22_04-lts-gen2"
      version = "latest"
    }
    custom_data = filebase64("apache.sh")

}


