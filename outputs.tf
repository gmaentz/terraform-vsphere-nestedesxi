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
  value = data.vsphere_virtual_machine.vm[*].guest_ip_addresses[0]
}