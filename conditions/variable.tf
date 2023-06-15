variable "resource" {
    type = object({
      name = string
      location = string
    })
  
}
variable "env" {
    type = string
  
}
variable "vnet" {
    type = object({
      name = string
      address_space = list(string)
    })
  
}
variable "subnets" {
    type = list(string)
  
}
variable "pubip" {
    type = object({
      name = list(string)
      allocation_method = string
    })
  
}
variable "nic" {
    type = list(string)
  
}
variable "vms" {
    type = list(string)
}
variable "server" {
    type = object({
      name = string
      version = string
      administrator_login = string
      administrator_login_password = string
    })
  
}
variable "database" {
    type = string
  
}