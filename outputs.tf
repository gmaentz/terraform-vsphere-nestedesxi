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

output "ESXi_hostnames" {
  value = vsphere_virtual_machine.vm[*].name
  # value = "${
  #   formatlist(
  #     "%s : %s",
  #     vsphere_virtual_machine.vm[*].name,
  #   vsphere_virtual_machine.vm[*].default_ip_address)
  # }"
}
output "ESXi_IP_addresses" {
  value = data.vsphere_virtual_machine.vm[*].guest_ip_addresses[0]_break
}

output "ESXi_root_password" {
  value = var.esxi_root_password_break
}