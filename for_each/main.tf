resource "azurerm_resource_group" "ab-resource" {
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
    depends_on = [ azurerm_resource_group.ab-resource ]
} 
resource "azurerm_subnet" "subnets" {
    for_each = var.vms_info
    name = each.value.subnet_names
    resource_group_name = var.resource.name
    virtual_network_name = var.vnet.name
    address_prefixes = each.value.address_prefixes
    depends_on = [ azurerm_resource_group.ab-resource,
    azurerm_virtual_network.vnet ]
}
resource "azurerm_public_ip" "pubip" {
    for_each = var.vms_info
    name = each.value.pub_ip_names
    resource_group_name = var.resource.name
    location = var.resource.location
    allocation_method = "Static"
    tags = {
      "env" = var.resource.tags
    }
}
resource "azurerm_network_interface" "nic" {
    for_each = var.vms_info
    name = each.value.nic_names
    resource_group_name = var.resource.name
    location = var.resource.location
    ip_configuration {
      name = each.value.nic_ip_names
      subnet_id = azurerm_subnet.subnets[each.key].id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.pubip[each.key].id
    } 
    depends_on = [azurerm_resource_group.ab-resource,
    azurerm_virtual_network.vnet,
    azurerm_subnet.subnets] 
    tags = {
      "env" = var.resource.tags
    }
}
resource "azurerm_linux_virtual_machine" "vm-1" {
    for_each = var.vms_info
    name = each.value.vm_names
    resource_group_name = var.resource.name
    location = var.resource.location
    size = each.value.vm_size
    admin_username = each.value.vm_username
    custom_data = filebase64(each.value.custom_data)
    network_interface_ids = [azurerm_network_interface.nic[each.key].id,]

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
    depends_on = [azurerm_resource_group.ab-resource]
}