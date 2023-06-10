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
variable "subnets" {
    type = list(string)
}
variable "pubip" {
    type = list(string)
  
}
variable "nic" {
    type = list(string)
  
}
variable "ukvms" {
    type = list(string)
  
}
variable "mssql" {
    type = object({
      name = string
      tags = string
    })
  
}
variable "database" {
    type = object({
      name = string
      tags = string
    })
  
}
variable "storage" {
    type = object({
      name = string
      tags = string
    })
  
}
