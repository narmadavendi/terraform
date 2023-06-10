resource "azurerm_resource_group" "uvresource" {
    name = var.resource.name
    location = var.resource.location
    tags = {
        "env" = "qa"
    }
    count = "${ terraform.workspace == "qa" ? 1 :0 }"

}
resource "azurerm_virtual_network" "vnet" {
    name = var.vnet.name
    location = var.resource.location
    resource_group_name = var.resource.name
    address_space = var.vnet.address_space
    tags = {
        "env" = "qa"
    }
    depends_on = [
         azurerm_resource_group.uvresource ]
    count = "${ terraform.workspace == "qa" ? 1 :0 }"     
  
}
resource "azurerm_subnet" "subnets" {
    name = "uvsubnet-${count.index}"
    resource_group_name = var.resource.name
    virtual_network_name = var.vnet.name
    address_prefixes = [cidrsubnet("10.0.0.0/16",8,count.index)]
    depends_on = [ 
        azurerm_resource_group.uvresource,
        azurerm_virtual_network.vnet
     ]
    count = "${ terraform.workspace == "qa" ? 3 :0 }" 
  
}
resource "azurerm_public_ip" "uvpubip" {
    name = "uvpubip-${count.index}"
    resource_group_name = var.resource.name
    location = var.resource.location
    allocation_method = "Static"
    tags = {
        "env" = "qa"
    }
    depends_on = [ azurerm_resource_group.uvresource ]
    count = "${ terraform.workspace == "qa" ? 3 :0 }"
  
}
resource "azurerm_network_interface" "uvnic" {
    name = "uvnic-${count.index}"
    location = var.resource.location
    resource_group_name = var.resource.name
    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnets[count.index].id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.uvpubip[count.index].id
    }
    count = "${ terraform.workspace == "qa" ? 3 :0 }"
}    
resource "azurerm_linux_virtual_machine" "uvvm" {
    name = "uvvm-${count.index}"
    resource_group_name = var.resource.name
    location = var.resource.location
    size = "Standard_B1ms"
    admin_username = "uv123"
    network_interface_ids = [
        azurerm_network_interface.uvnic[count.index].id,
    ]
    count = "${ terraform.workspace == "qa" ? 3 :0 }"

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
resource "null_resource" "executor" {
    triggers = {
        rollout_version = var.rollout_version
    }
    count = "${ terraform.workspace == "qa" ? 1 :0 }"
    connection {
      type = "ssh"
      user =  azurerm_linux_virtual_machine.uvvm[0].admin_username
      private_key = file("~/.ssh/id_rsa")
      host = azurerm_linux_virtual_machine.uvvm[0].public_ip_address

    }
    provisioner "remote-exec" {
        inline = [ "sudo apt update","sudo apt install apache2 -y" ]
      
    }
  
}
resource "null_resource" "executor1" {
    triggers = {
        rollout_version = var.rollout_version1
    }
    count = "${ terraform.workspace == "qa" ? 1 :0 }"
    connection {
      type = "ssh"
      user =  azurerm_linux_virtual_machine.uvvm[1].admin_username
      private_key = file("~/.ssh/id_rsa")
      host = azurerm_linux_virtual_machine.uvvm[1].public_ip_address

    }
    provisioner "remote-exec" {
        inline = [ "sudo apt update","sudo apt install nginx -y" ]
      
    }
  
}
resource "null_resource" "executor2" {
    triggers = {
        rollout_version = var.rollout_version2
    }
    count = "${ terraform.workspace == "qa" ? 1 :0 }"
    connection {
      type = "ssh"
      user =  azurerm_linux_virtual_machine.uvvm[2].admin_username
      private_key = file("~/.ssh/id_rsa")
      host = azurerm_linux_virtual_machine.uvvm[2].public_ip_address
    }
    provisioner "remote-exec" {
        inline = ["sudo apt update",
            "sudo apt install software-properties-common -y",
            "sudo add-apt-repository --yes --update ppa:ansible/ansible",
            "sudo apt install ansible -y"
            
        ]
    }
}    