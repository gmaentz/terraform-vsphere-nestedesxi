# Note, Terraform will throw an error trying to display the IP address if DHCP is used.
# Wait approximately 3 minutes after resources are created and run 'terraform refresh' to
# retreive the proper hostname/IP address output.
#
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
  value = vsphere_virtual_machine.vm[*].default_ip_address
}