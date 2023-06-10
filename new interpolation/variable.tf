variable "resource" {
    type = object({
      name = string
      location = string
    })
  
}
variable "vnet" {
    type = object({
      name = string
      address_space = list(string)
    })
  
}
variable "uvvm" {
    type = number
  
}
variable "sqlserver" {
    type = string
  
}
variable "sqldatabase" {
    type = string
  
}
variable "storage" {
    type = string
  
}
variable "rollout_version" {
    type = string
  
}
variable "rollout_version1" {
    type = string
  
}
variable "rollout_version2" {
    type = string
  
}