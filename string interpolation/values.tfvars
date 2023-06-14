resource = {
    name = "uk_resource"
    location = "westus"
    tags = "dev"
}
vnet = {
  name = "uk_vnet"
  address_space = [ "192.168.0.0/16" ]
  tags = "dev"
}

vms = "3"