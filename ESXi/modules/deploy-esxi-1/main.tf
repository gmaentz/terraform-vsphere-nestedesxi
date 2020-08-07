provider "vsphere" {
  version        = "1.21.1"
  user           = var.vcenter_user
  password       = var.vcenter_password
  vsphere_server = var.vcenter_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter_name
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = var.source_esxi_host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
# data "vsphere_content_library" "library" {
#   name = "Nested ESXi"
# }
# data "vsphere_content_library_item" "item" {
#   name       = "Nested_ESXi6.7_Appliance_Template_v1.0"
#   library_id = data.vsphere_content_library.library.id
# }
resource "vsphere_virtual_machine" "vmFromLocalOvf" {
  count = var.num_esxi_hosts
  name = "${var.name_prefix}${format("%0000d", count.index + 1 + var.offset)}"
  #folder = "terraform"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id = data.vsphere_datastore.datastore.id
  datacenter_id = data.vsphere_datacenter.datacenter.id
  host_system_id = data.vsphere_host.host.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout = 0

  ovf_deploy {
    local_ovf_path = "C:\\Nested_ESXi6.7_Appliance_Template_v1.ova"
    disk_provisioning = "thin"
    ip_protocol          = "IPV4"
    ip_allocation_policy = "DHCP"
    ovf_network_map = {
        "VM-Network-DVPG" = data.vsphere_network.network.id
    }
  }

  vapp {
    properties = {
      "guestinfo.hostname" = "${var.name_prefix}${format("%0000d", count.index + 1 + var.offset)}",
      "guestinfo.ipaddress" = "",
      "guestinfo.netmask" = "",
      "guestinfo.gateway" = "",
      "guestinfo.dns" = "",
      "guestinfo.domain" = "",
      "guestinfo.ntp" = "us.pool.ntp.org",
      "guestinfo.password" = "RPTpass123!",
      "guestinfo.ssh" = "True"
    }
  }
}