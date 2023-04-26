resource "azurerm_resource_group" "narmada-resource" {
  name     = "narmada1-resource"
  location = "East US"
  tags = {
    "env" = "dev"
  }
}
resource "azurerm_virtual_network" "narmada-vnet" {
  name                = "narmada1-network"
  resource_group_name = "narmada1-resource"
  location            = "East US"
  address_space       = ["10.0.0.0/16"]
  tags = {
    "env" = "dev"
  }
  depends_on = [
    azurerm_resource_group.narmada-resource
  ]
} 
resource "azurerm_subnet" "narmada-subnet" {
  name                 = "narmada1-subnet"
  resource_group_name  = "narmada1-resource"
  virtual_network_name = "narmada1-network"
  address_prefixes     = ["10.0.0.0/24"]
  depends_on = [
    azurerm_resource_group.narmada-resource,
    azurerm_virtual_network.narmada-vnet
  ]
}
resource "azurerm_public_ip" "narmada-pub-ip" {
  name = "narmada1-pub-ip"
  resource_group_name = azurerm_resource_group.narmada-resource.name
  location            = azurerm_resource_group.narmada-resource.location
  allocation_method = "Static"
  tags = {
    "env" = "dev"
  }
}
resource "azurerm_network_interface" "narmada-nic" {
  name = "narmada1-nic"
  resource_group_name = azurerm_resource_group.narmada-resource.name
  location            = azurerm_resource_group.narmada-resource.location
  ip_configuration {
    name = "internal" 
    subnet_id           = azurerm_subnet.narmada-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.narmada-pub-ip.id
  }
  depends_on = [
    azurerm_subnet.narmada-subnet
  ]
}  
resource "azurerm_virtual_machine" "narmada_vm" {
  name = "narmada1-vm"
  resource_group_name = azurerm_resource_group.narmada-resource.name
  location = azurerm_resource_group.narmada-resource.location
  network_interface_ids = [azurerm_network_interface.narmada-nic.id]
  vm_size = "Standard_B2s"

 storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "narmadadisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "narmada-world"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    "env" = "dev"
  }
}   