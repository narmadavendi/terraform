resource "azurerm_resource_group" "cd-resource" {
    name = var.resource1.name
    location = var.resource1.location
    tags = {
      "env" = var.resource1.tags
    }
}
# resource "azurerm_resource_group" "ef-resource" {
#     name = var.resource.name
#     location = var.resource.location
#     tags = {
#       "env" = var.resource.tags
#     }
# }
resource "azurerm_virtual_network" "vnet1" {
    name = var.vnet1.name
    resource_group_name = var.resource1.name
    location = var.resource1.location
    address_space = var.vnet1.address_space
    tags = {
      "env" = var.resource1.tags
    }
    depends_on = [ azurerm_resource_group.cd-resource ]
}
# resource "azurerm_virtual_network" "vnet" {
#     name = var.vnet.name
#     resource_group_name = var.resource.name
#     location = var.resource.location
#     address_space = var.vnet.address_space
#     tags = {
#       "env" = var.resource.tags
#     }
#     depends_on = [ azurerm_resource_group.ef-resource ]
# }
resource "azurerm_subnet" "subnets" {
    count = var.v-machine
    name = "web-${count.index}"
    resource_group_name = var.resource1.name
    virtual_network_name = var.vnet1.name
    address_prefixes = [cidrsubnet("192.168.0.0/16",8,count.index)]
    depends_on = [ azurerm_resource_group.cd-resource,
        azurerm_virtual_network.vnet1 ]
}
resource "azurerm_public_ip" "pubip" {
    count = var.v-machine
    name = "pubip-${count.index}"
    resource_group_name = var.resource1.name
    location = var.resource1.location
    allocation_method = "Static"
    tags = {
      "env" = var.resource1.tags
    }
    depends_on = [ azurerm_resource_group.cd-resource ]
}
resource "azurerm_network_interface" "nic" {
    count = var.v-machine
    name = "nic-${count.index}"
    resource_group_name = var.resource1.name
    location = var.resource1.location
    ip_configuration {
      name = "narmada"
      subnet_id = azurerm_subnet.subnets[count.index].id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.pubip[count.index].id
    }
    tags = {
      "env" = var.resource1.tags
    }
    depends_on = [ azurerm_resource_group.cd-resource,
    azurerm_virtual_network.vnet,
    azurerm_subnet.subnets ]
  
}
resource "azurerm_linux_virtual_machine" "vm" {
    count = var.v-machine
    name = "vm-${count.index}"
    resource_group_name = var.resource1.name
    location = var.resource1.location
    size = "Standard_B1s"
    admin_username = "narmadavendi123"
    network_interface_ids = [azurerm_network_interface.nic[count.index].id,]

    admin_ssh_key {
      username = "narmadavendi123"
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
    depends_on = [ azurerm_resource_group.cd-resource ,]
}
resource "null_resource" "executor1" {
    triggers = {
        rollout_version = "0.0.1.0"
    }
    count = var.v-machine
    connection {
      type = "ssh"
      user = azurerm_linux_virtual_machine.vm[0].admin_username
      private_key = file("~/.ssh/id_rsa")
      host = azurerm_linux_virtual_machine.vm[0].public_ip_address
    }
    provisioner "remote-exec" {
        inline = [ "sudo apt update",
        "sudo apt install apache2 -y" ]
      
    }
}
resource "null_resource" "executor2" {
    triggers = {
        rollout_version1 = "0.0.2.0"
    }
    count = var.v-machine
    connection {
      type = "ssh"
      user = azurerm_linux_virtual_machine.vm[1].admin_username
      private_key = file("~/.ssh/id_rsa")
      host = azurerm_linux_virtual_machine.vm[1].public_ip_address
    }
    provisioner "remote-exec" {
        inline = [ "sudo apt update",
        "sudo apt install nginx -y" ]
    }
}
