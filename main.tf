resource "azurerm_resource_group" "tf_rsg" {
  count = length(var.rsg_details.rsg_tag)
  location = var.rsg_details.location[count.index]
  name     = var.rsg_details.rsg_name[count.index]
  tags = {
    "Name" = var.rsg_details.rsg_tag[count.index]
    "Environment" = var.rsg_details.env[count.index]
  }
}
