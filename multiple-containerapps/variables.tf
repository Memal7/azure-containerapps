variable "aca_name" {
  type        = string
  default = "myacaapp-demo"
}
variable "location" {
  default     = "Sweden Central"
  type        = string
}

variable "infrastructure_subnet_id" {
  type        = string
default = "/subscriptions/{subscription-id}/resourceGroups/{rg-init}/providers/Microsoft.Network/virtualNetworks/{aca-vnet}/subnets/{aca-app}"
}