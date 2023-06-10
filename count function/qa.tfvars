resource = {
  name     = "us_resource"
  location = "west us"
  tags     = "qa"

}
vnet = {
  name          = "us_vnet"
  address_space = ["192.168.0.0/16"]
  tags          = "qa"
}
subnets = ["us1", "us2", "us3"]
pubip = {
  name              = ["usip1", "usip2", "usip3"]
  tags              = "qa"
  allocation_method = "Static"
}
nic = ["nic1", "nic2", "nic3"]
vms = ["vm1", "vm2", "vm3"]
sqlserver = {
  name                        = "ggjhki"
  administrate_login          = "narmadatomndjerry"
  administrate_login_password = "Narmada12345398$"
  version                     = "12.0"
  tags                        = "qa"
}
database = {
  name = "gjkkl"
  #   server_id = "azurerm_mssql_server.sqlserver.id"
  tags = "qa"
}
storage = {
  name                     = "qwjdub"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags                     = "qa"
}


