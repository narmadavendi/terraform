variable "resource" {
    type = object({
      name = string
      location = string
      tags = string
    })
    default = {
      name = "ab_resource"
      location = "UK south"
      tags = "dev"
    }
}
variable "vnet" {
    type = object({
      name = string
      address_space = list(string)
    })
    default = {
      name = "ab_vnet"
      address_space = ["192.168.0.0/16"]
    }
}
variable "vms_info" {
    type = map(object({
      subnet_names = string
      address_prefixes = list(string)
      nic_names = string
      nic_ip_names = string
      pub_ip_names = string
      vm_names = string
      vm_size = string
      vm_username = string
      image_publisher = string
      image_offer = string
      image_sku = string
      image_version = string
      custom_data = string
    #   zone = number
    }))
    default = {
        "vm1" = {
            subnet_names = "web1"
            address_prefixes = ["192.168.1.0/24"]
            nic_names = "nic1"
            nic_ip_names = "nicip1"
            pub_ip_names = "pubip1"
            vm_names = "tomvm"
            vm_size = "Standard_B1s"
            vm_username = "narmadavendi"
            image_publisher = "Canonical"
            image_offer = "UbuntuServer"
            image_sku = "18.04-LTS"
            image_version = "latest"
            custom_data =  "./apache.sh"
      }
        "vm2" = {
            subnet_names = "web2"
            address_prefixes = ["192.168.2.0/24"]
            nic_names = "nic2"
            nic_ip_names = "nicip2"
            pub_ip_names = "pubip2"
            vm_names = "jerryvm"
            vm_size = "Standard_B1s"
            vm_username = "narmadavendi"
            image_publisher = "Canonical"
            image_offer = "UbuntuServer"
            image_sku = "18.04-LTS"
            image_version = "latest"
            custom_data =  "./nginx.sh"
            }
      "vm3" = {
            subnet_names = "web3"
            address_prefixes = ["192.168.3.0/24"]
            nic_names = "nic3"
            nic_ip_names = "nicip3"
            pub_ip_names = "pubip3"
            vm_names = "honeyvm"
            vm_size = "Standard_B1s"
            vm_username = "narmadavendi"
            image_publisher = "Canonical"
            image_offer = "UbuntuServer"
            image_sku = "18.04-LTS"
            image_version = "latest"
            custom_data =  "./ansible.sh"
      }
    }
}
