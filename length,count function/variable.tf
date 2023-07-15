variable "subnets" {
    type = list(string)
    default = [ "web","app","db" ]
  
}
variable "pubip" {
    type = object({
      name = list(string)
      allocation_method = string
    })
    default = {
      name = [ "pubip1","pubip2","pubip3" ]
      allocation_method = "Static"
    }
  
}
variable "nic" {
    type = list(string)
    default = [ "web1","web2","web3" ]
}
variable "vms" {
    type = list(string)
    default = [ "vm1","vm2","vm3" ]
  
}
# variable "source_image" {
#     type = object({
#       publisher = string
#       offer = string
#       sku = string
#       version = string
#     })
#     default = {
#       publisher = "Canonical"
#       offer = "0001-com-ubuntu-server-focal"
#       sku = "20_04-lts"
#       version = "latest"
#     }
  
# }