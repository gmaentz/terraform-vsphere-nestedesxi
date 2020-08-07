variable "vcenter_user" {
  default = "administrator@vsphere.local"
}
variable "vcenter_password" {
  default = "RPTpass123!"
}
variable "vcenter_server" {
  default = "192.168.169.35"
}
variable "datacenter_name" {
  default = "Datacenter"
}
variable "datastore_name" {
  default = "raid10_gen7"
}
variable "resource_pool" {
  default = "192.168.169.34/Resources"
}
variable "network_name" {
  default = "VM Network"
}
variable "source_esxi_host" {
  default = "192.168.169.34"
}
variable "num_esxi_hosts" {
  default = 9
}
variable "nameprefix" {
  default = "esxi67t000"
}
variable "offset" {
  default = 0
}