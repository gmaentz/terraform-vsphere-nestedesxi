################################################################################
################################################################################
################################################################################
###                                                                          ###
### Name: terraform-vsphere-nestedesxi                                       ###
### Description: [Terraform] Module to create nested ESXi VMs                ###
### Last Modified: fparry(2020-09-04T11:12:56-04:00)                         ###
### License: MIT (See LICENSE.txt in the root of this repository for more    ###
###   information.)                                                          ###
###                                                                          ###
################################################################################
################################################################################
################################################################################

variable "vcenter_user" {
  description = "Source vCenter Username"
}
variable "vcenter_password" {
  description = "Source vCenter password"
}
variable "vcenter_server" {
  description = "Source vCenter hostname or IP address"
}
variable "esxi_root_password" {
  description = "Set the nested ESXi hosts root password"
}
variable "datacenter_name" {
  description = "Datacenter name in source vCenter"
}
variable "datastore_name" {
  description = "Where to store the nested ESXi VMs"
}
variable "resource_pool" {
  description = "Specify resource pool for nested ESXi VMs"
}
variable "network_name" {
  description = "Virtual network name"
}
variable "source_esxi_host" {
  description = "Specify source ESXi source IP address"
}
variable "num_esxi_hosts" {
  description = "How many nested ESXi hosts do you want to build?"
  default     = 1
}
variable "nameprefix" {
  description = "Nested ESXi hostname prefix"
}
variable "offset" {
  description = "Offset default value 1, for naming"
  default     = 1
}
variable "vm_template_name" {
  description = "Specify source VM template"
}
variable "hostipaddress" {
  description = "List of IP addresses to be assigned (required when useDHCP is set to false)"
  type        = list
  default     = ["192.168.169.230"]
}
variable "hostnetmask" {
  description = "Subnet mask for nested hosts (required when useDHCP is set to false)"
}
variable "hostgateway" {
  description = "IP gateway for nested hosts (required when useDHCP is set to false)"
}
variable "hostdnsservers" {
  description = "DNS servers for nested hosts"
}
variable "hostdomainname" {
  description = "DNS suffix for nested hosts"
}
variable "useDHCP" {
  description = "If set to 'false', you must set the values for 'hostnetmask', 'hostgateway', and 'hostipaddress'.  If 'true', those values are ignored."
  type        = bool
}
variable "emptystring" {
  description = "Null string - keep default"
  default     = ""
}