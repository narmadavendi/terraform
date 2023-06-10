resource = {
    name = "uk_resource"
    location = "west us"
    tags = "uat"
}    
vnet = {
  name = "uk_vnet"
  address_space = [ "10.0.0.0/16" ]
  tags = "uat"
}
subnets = [ "uk1","uk2","uk3" ]
pubip = [ "ukip1","ukip2","ukip3" ]
nic = [ "nic1","nic2","nic3" ]
ukvms = [ "ukvm1","ukvm2","ukvm3" ]
mssql = {
  name = "ukmssql"
  tags = "uat"
}
database = {
  name = "ukdatabase"
  tags = "uat"
}
storage = {
  name = "abcdefgh12345storage"
  tags = "uat"
}
