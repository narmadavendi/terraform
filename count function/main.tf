resource "azurerm_resource_group" "usresource" {
  count = "${ terraform.workspace == "dev" ? 1:0 }"  
  name     = var.resource.name
  location = var.resource.location
  tags = {
    "env" = var.resource.tags
  }
}
resource "azurerm_virtual_network" "vnet" {
  count = "${ terraform.workspace == "dev" ? 1:0 }" 
  name                = var.vnet.name
  resource_group_name = var.resource.name
  location            = var.resource.location
  address_space       = var.vnet.address_space
  tags = {
    "env" = var.vnet.tags
  }
  depends_on = [azurerm_resource_group.usresource]
}
resource "azurerm_subnet" "subnets" {
  count                = "${ terraform.workspace == "dev" ? 3:0 }"
  name                 = var.subnets[count.index]
  resource_group_name  = var.resource.name
  virtual_network_name = var.vnet.name
  address_prefixes     = [cidrsubnet("192.168.0.0/16", 8, count.index)]
  depends_on = [azurerm_resource_group.usresource,
  azurerm_virtual_network.vnet]

}
resource "azurerm_public_ip" "pubip" {
  count               = "${ terraform.workspace == "dev" ? 3:0 }"
  name                = var.pubip.name[count.index]
  resource_group_name = var.resource.name
  location            = var.resource.location
  allocation_method   = var.pubip.allocation_method
  tags = {
    "env" = var.pubip.tags
  }
  depends_on = [azurerm_resource_group.usresource]

}
resource "azurerm_network_interface" "nic" {
  count               = "${terraform.workspace == "dev" ? 3:0 }"
  name                = var.nic[count.index]
  location            = var.resource.location
  resource_group_name = var.resource.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip[count.index].id
  }
}
resource "azurerm_linux_virtual_machine" "vms" {
  count               = "${ terraform.workspace == "dev" ? 3:0 }"
  name                = var.vms[count.index]
  resource_group_name = var.resource.name
  location            = var.resource.location
  size                = "Standard_B1s"
  admin_username      = "narmadavendi"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
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
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  } 
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = azurerm_linux_virtual_machine.vms[1].admin_username
      private_key = file("~/.ssh/id_rsa")
      host        = azurerm_linux_virtual_machine.vms[1].public_ip_address
    }
    inline = ["sudo apt update", "sudo apt install nginx -y"]
  }

  
}

resource "null_resource" "executor" {
    count = "${ terraform.workspace == "dev" ? 1:0 }"
    triggers = {
        rollout_version = "0.0.2.0"
    }
    connection {
        type = "ssh"
        user = azurerm_linux_virtual_machine.vms[0].admin_username
        private_key = file("~/.ssh/id_rsa")
        host = azurerm_linux_virtual_machine.vms[0].public_ip_address
    }
    provisioner "remote-exec" {
        inline = ["sudo apt update","sudo apt install apache2 -y"]
    }
    depends_on = [
    azurerm_linux_virtual_machine.vms
  ]
    
} 

resource "null_resource" "executor1" {
    count = "${ terraform.workspace == "dev" ? 1:0 }"
    triggers = {
        rollout_version1 = "0.0.3.0"
    }
    connection {
        type = "ssh"
        user = azurerm_linux_virtual_machine.vms[2].admin_username
        private_key = file("~/.ssh/id_rsa")
        host = azurerm_linux_virtual_machine.vms[2].public_ip_address
    }
    provisioner "remote-exec"  {
        inline = ["sudo apt update",
            "sudo apt install software-properties-common -y",
            "sudo add-apt-repository --yes --update ppa:ansible/ansible",
            "sudo apt install ansible -y"
            
        ]
    }
    depends_on = [
    azurerm_linux_virtual_machine.vms
  ]

    
}




