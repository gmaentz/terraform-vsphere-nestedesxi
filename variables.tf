variable "vcenter_user" {}
variable "vcenter_password" {}
variable "vcenter_server" {}
variable "esxi_root_password" {}
variable "datacenter_name" {}
variable "datastore_name" {}
variable "resource_pool" {}
variable "network_name" {}
variable "source_esxi_host" {}
variable "num_esxi_hosts" {
  default = 1
}
variable "nameprefix" {}
variable "offset" {
  default = 1
}
variable "vm_template_name" {}
variable "hostipaddress" {
  type = list
}