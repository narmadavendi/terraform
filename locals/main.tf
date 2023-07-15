resource "azurerm_resource_group" "gh-rg" {
    name = local.name
    location = local.location
    tags = {
      "env" = local.tags
    }
}
resource "azurerm_virtual_network" "vnet" {
    name = local.name1
    resource_group_name = local.name
    location = local.location
    address_space = local.address_space
    tags = {
      "env" = local.tags
    }
    depends_on = [ azurerm_resource_group.gh-rg ]
}
resource "azurerm_subnet" "subnets" {
    count = 3
    name = local.names[count.index]
    resource_group_name = local.name
    virtual_network_name = local.name1
    address_prefixes = [cidrsubnet("192.168.0.0/16",8,count.index)]
    depends_on = [ azurerm_virtual_network.vnet ]
}
resource "azurerm_public_ip" "pubip" {
    count = 3
    name = local.name2[count.index]
    resource_group_name = local.name
    location = local.location
    allocation_method = local.allocation_method
    tags = {
      "env" = local.tags
    }
}
resource "azurerm_network_interface" "nic" {
    count = 3
    name = local.name3[count.index]
    resource_group_name = local.name
    location = local.location
    ip_configuration {
      name = local.name4[count.index]
      subnet_id = azurerm_subnet.subnets[count.index].id
      private_ip_address_allocation = local.private_ip_address_allocation
      public_ip_address_id = azurerm_public_ip.pubip[count.index].id
    }
    depends_on = [ azurerm_virtual_network.vnet,
    azurerm_subnet.subnets ]
}
resource "azurerm_linux_virtual_machine" "vms" {
    count = 3
    name = local.name5[count.index]
    resource_group_name = local.name
    location = local.location
    size = local.size
    admin_username = local.admin_username
    network_interface_ids =[ azurerm_network_interface.nic[count.index].id,]
    admin_ssh_key {
      username = local.admin_username
      public_key = file("~/.ssh/id_rsa.pub")
    }
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference {
      publisher = local.publisher
      offer = local.offer
      sku = local.sku
      version = local.version
    }
  depends_on = [ azurerm_resource_group.gh-rg ,
  azurerm_network_interface.nic]
}
resource "null_resource" "executor" {
    triggers = {
      rollout_version = local.rollout_version
    }
    connection {
      type = "ssh"
      user = azurerm_linux_virtual_machine.vms[0].admin_username
      private_key = file("~/.ssh/id_rsa")
      host = azurerm_linux_virtual_machine.vms[0].public_ip_address
    }
    provisioner "remote-exec" {
        inline = [ "sudo apt update","sudo apt install apache2 -y" ]
      
    }
  
}
resource "null_resource" "executor1" {
    triggers = {
        rollout_version1 = local.rollout_version1
    }
    connection {
        type = "ssh"
        user = azurerm_linux_virtual_machine.vms[1].admin_username
        private_key = file("~/.ssh/id_rsa")
        host = azurerm_linux_virtual_machine.vms[1].public_ip_address
    }
    provisioner "remote-exec"  {
      inline = [ "sudo apt update","sudo apt install nginx -y" ]
    }
    depends_on = [
    azurerm_linux_virtual_machine.vms
     ]
}
resource "null_resource" "executor2" {
    triggers = {
        rollout_version1 = local.rollout_version2
    }
    connection {
        type = "ssh"
        user = azurerm_linux_virtual_machine.vms[2].admin_username
        private_key = file("~/.ssh/id_rsa")
        host = azurerm_linux_virtual_machine.vms[2].public_ip_address
    }
    provisioner "remote-exec"  {
      inline = [ "sudo apt-get update", "sudo apt install docker.io -y","sudo snap install docker","docker --version"]
    }
    depends_on = [
    azurerm_linux_virtual_machine.vms
     ]
}
