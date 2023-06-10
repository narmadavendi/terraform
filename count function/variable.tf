variable "resource" {
  type = object({
    name     = string
    location = string
    tags     = string
  })
}
variable "vnet" {
  type = object({
    name          = string
    address_space = list(string)
    tags          = string
  })

}
variable "subnets" {
  type = list(string)
}
variable "pubip" {
  type = object({
    name              = list(string)
    tags              = string
    allocation_method = string
  })

}
variable "nic" {
  type = list(string)

}
variable "vms" {
  type = list(string)

}
variable "sqlserver" {
  type = object({
    name                        = string
    administrate_login          = string
    administrate_login_password = string
    tags                        = string
    version                     = string


  })

}
variable "database" {
  type = object({
    name = string
    # server_id = string
    tags = string
  })

}
variable "storage" {
  type = object({
    name                     = string
    account_tier             = string
    account_replication_type = string
    tags                     = string
  })

}