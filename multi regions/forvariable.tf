resource "azurerm_resource_group" "ef-resource" {
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
      "env" = var.resource.tags
    }
    depends_on = [ azurerm_resource_group.ef-resource ]
}
resource "azurerm_subnet" "networks" {
    for_each = var.vms_info
    name = each.value.subnet_names
    resource_group_name = var.resource.name
    virtual_network_name = var.vnet.name
    address_prefixes = each.value.address_prefixes
    depends_on = [ azurerm_resource_group.ef-resource,
        azurerm_virtual_network.vnet ]
}
resource "azurerm_public_ip" "publicip" {
    for_each = var.vms_info
    name = each.value.pub_ip_names
    resource_group_name = var.resource.name
    location = var.resource.location
    allocation_method = "Static"
    tags = {
      "env" = var.resource.tags
    }
    depends_on = [ azurerm_resource_group.ef-resource ]
  
}
resource "azurerm_network_interface" "networknic" {
    for_each = var.vms_info
    name = each.value.nic_names
    resource_group_name = var.resource.name
    location = var.resource.location
    ip_configuration {
      name = each.value.nic_ip_names
      subnet_id = azurerm_subnet.networks[each.key].id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id =  azurerm_public_ip.publicip[each.key].id
    }
    tags = {
        "env" = var.resource.tags
    }
    depends_on = [ azurerm_resource_group.ef-resource,
    azurerm_virtual_network.vnet,
    azurerm_subnet.networks ]
}
resource "azurerm_linux_virtual_machine" "vms_info" {
    for_each = var.vms_info
    name = each.value.vm_names
    resource_group_name = var.resource.name
    location = var.resource.location
    size = each.value.vm_size
    admin_username = each.value.vm_username
    custom_data = filebase64(each.value.custom_data)
    network_interface_ids = [azurerm_network_interface.networknic[each.key].id,]

    admin_ssh_key {
      username = each.value.vm_username
      public_key = file("~/.ssh/id_rsa.pub")
    }
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference {
      publisher = each.value.image_publisher
      offer = each.value.image_offer
      sku = each.value.image_sku
      version = each.value.image_version
    }
    depends_on = [ azurerm_resource_group.ef-resource ]
}
# resource "null_resource" "executor3" {
#     for_each = toset(var.vms_info)
#     triggers = {
#       rollout_version = "0.0.1.0"      
#     }
#     connection {
#       type = "ssh"
#       username = azurerm_linux_virtual_machine.vm1[each.key].admin_username
#       private_key = file("~/.ssh/id_rsa")
#       host = azurerm_linux_virtual_machine.vm1[each.key].public_ip_address
#     }
#     provisioner "remote-exec" {
#         inline = ["sudo apt update",
#             "sudo apt install software-properties-common -y",
#             "sudo add-apt-repository --yes --update ppa:ansible/ansible",
#             "sudo apt install ansible -y"]
#       }
# }
# resource "null_resource" "executor4" {
#   for_each = toset(var.vms_info)
#     triggers = {
#       rollout_version1 = "0.0.2.0"
#     }
#     connection {
#       type = "ssh"
#       username = azurerm_linux_virtual_machine.vm2[each.key].admin_username
#       private_key = file("~/.ssh/id_rsa")
#       host = azurerm_linux_virtual_machine.vm2[each.key].public_ip_address
#     }
#     provisioner "remote-exec" {
#         inline = [ "sudo apt update",
#         "sudo apt install docker.io",
#         "sudo snap install docker",
#          "docker --version"]
#     }
#     depends_on = [ azurerm_linux_virtual_machine.vms_info ]
# }
