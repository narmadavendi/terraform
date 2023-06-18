module "azurevm" {
    source = "./az_vnet"

    azres = {
      name = "az_resource"
      location = "East Us"
    }
    vnet = {
      name = "az_vnet"
      address_space = ["192.168.0.0/16"]
    }
    subnets = "tomsubnet"
    pubip =  {
      name = "tom-pub"
      allocation_method = "Static"
    }
    nic = "tom-nic"
    vm = "tom-vm"
}
    resource "null_resource" "executor" {
    triggers = {
        rollout_version = "0.0.1.0"
    } 
    connection {
      type = "ssh"
      user = "narmadavendi"
      private_key = file("~/.ssh/id_rsa")
      host = module.azurevm.public_ip
    }
    provisioner "remote-exec" {
        script = "./java.sh"
      
    }
    depends_on = [module.azurevm]
}