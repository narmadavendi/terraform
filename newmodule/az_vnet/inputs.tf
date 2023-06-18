variable "azres" {
    type = object({
      name = string
      location = string
    })
    default = {
      name = "az_resource"
      location = "East Us"
    }
}
variable "vnet" {
  type = object({
    name = string
    address_space = list(string)
  })
  default = {
    name = "az_vnet"
    address_space = [ "192.168.0.0/16" ]
  }
  
}
variable "subnets" {
  type = string
  default = "tomsubnet"
  
} 
variable "pubip" {
  type = object({
    name = string
    allocation_method = string
  })
  default = {
    name = "tom-pub"
    allocation_method = "Static"
  }
}
variable "nic" {
  type = string
  default = "tom-nic"
}
variable "vm" {
  type = string
  default = "tom-vm"
  
}
 
