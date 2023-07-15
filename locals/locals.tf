locals {
  name = "gh_resource"
  location = "West Us"
  tags = "dev"
}
locals {
  name1 = "gh_vnet"
  address_space = ["192.168.0.0/16"]
}
locals {
  names = ["sub1","sub2","sub3"]
}
locals {
  name2 = ["pub1","pub2","pub3"]
  allocation_method = "Static"
}
locals {
  name3 = ["nic1","nic2","nic3"]
}
locals {
  name4 = ["ip1","ip2","ip3"]
  private_ip_address_allocation = "Dynamic"
}
locals {
  name5 = ["vm1","vm2","vm3"]
  size = "Standard_B1ms"
  admin_username = "narmadavendi"
}
locals {
  publisher = "Canonical"
  offer = "0001-com-ubuntu-server-focal"
  sku = "20_04-lts"
  version = "latest"
}
locals {
  rollout_version = "0.0.1.0"
  rollout_version1 = "0.0.2.0"
  rollout_version2 = "0.0.3.0"
}
locals {
  name6 = "nsg-name"
}
