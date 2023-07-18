variable "resource1" {
    type = object({
      name = string
      location = string
      tags = string
    })
    default = {
      name = "cd_resource"
      location = "West us"
      tags = "dev"
    }
}
# variable "resource" {
#     type = object({
#       name = string
#       location = string
#       tags = string
#     })
#     default = {
#       name = "ef_resource"
#       location = "UK south"
#       tags = "qa"
#     }
# }
variable "vnet1" {
    type = object({
      name = string
      address_space = list(string)
    })
    default = {
      name = "cd_vnet"
      address_space = ["192.168.0.0/16"]
    }
}
# variable "vnet" {
#     type = object({
#       name = string
#       address_space = list(string)
#     })
#     default = {
#       name = "ef_vnet"
#       address_space = [ "10.0.0.0/16" ]
#     }
# }
variable "v-machine" {
    type = number
    default = 2
}
