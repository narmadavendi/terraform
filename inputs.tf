# variable "location" {
#     type = string
#     default = "Eastus"
#     description = "selecting location for resource group"
# }

variable "rsg_details" {
    type = object({
        location = list(string)
        rsg_name = list(string)
        rsg_tag = list(string)
        env = list(string)
    })
}