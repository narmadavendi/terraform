variable "resource" {
    type = object({
      name = string
      location = string
      tags = string
    })
    default = {
      name = "ef_resource"
      location = "UK south"
      tags = "qa"
    }
}
variable "vnet" {
    type = object({
      name = string
      address_space = list(string)
    })
    default = {
      name = "ef_vnet"
      address_space = [ "10.0.0.0/16" ]
    }
}
variable "vms_info" {
    type = map(object({
      subnet_names = string
      address_prefixes = list(string)
      nic_names = string
      nic_ip_names = string
      pub_ip_names =string
      vm_names =string
      vm_size = string
      vm_username = string
      image_publisher = string
      image_offer = string
      image_sku = string
      image_version = string
      custom_data = string
    }))
    default = {
      "vm1" = {
      subnet_names = "app1"
      address_prefixes = ["10.0.1.0/24"]
      nic_names = "network1"
      nic_ip_names = "nicip1"
      pub_ip_names = "publicip1"
      vm_names = "narmada"
      vm_size = "Standard_B1s"
      vm_username = "narmadavendi"
      image_publisher = "Canonical"
      image_offer = "0001-com-ubuntu-server-jammy"
      image_sku = "22_04-lts-gen2"
      image_version = "latest"
      custom_data = "D:/terraform/multi regions/apache.sh"
      }
      "vm2" = {
      subnet_names = "app2"
      address_prefixes = ["10.0.2.0/24"]
      nic_names = "network2"
      nic_ip_names = "nicip2"
      pub_ip_names = "publicip2"
      vm_names = "narmada2"
      vm_size = "Standard_B1s"
      vm_username = "narmadavendi"
      image_publisher = "Canonical"
      image_offer = "0001-com-ubuntu-server-jammy"
      image_sku = "22_04-lts-gen2"
      image_version = "latest"
      custom_data = "D:/terraform/multi regions/nginx.sh"
      }
    }
}