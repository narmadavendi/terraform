variable "resource" {
  type = object({
    name = string
    location = string
    tags = string 
  })
}
variable "vnet" {
    type = object({
      name = string
      address_space = list(string)
      tags = string
    })
  
}
variable "vms" {
    type = number
  
}
