resource = {
  name = "qa_resource"
  location = "west us"
}
env = "dev"
vnet = {
  name = "qa_vnet"
  address_space = ["192.168.0.0/16"]
}
subnets = [ "web","app" ]
pubip = {
  name = [ "pubip1","pubip2" ]
  allocation_method = "Static"
}
nic = [ "nic1","nic2" ]
vms = [ "vm1","vm2" ]
server = {
  name = "hjhjfhff"
  version = "12.0"
  administrator_login = "dfghjkjk"
  administrator_login_password = "dfgjkljik123456$"
}
database = "kdsfkfjkj"