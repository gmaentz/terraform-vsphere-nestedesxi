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

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# data "vsphere_content_library" "library" {
#   name = "Nested ESXi"
# }

# data "vsphere_content_library_item" "item" {
#   name       = "Nested_ESXi6.7_Appliance_Template_v1.0"
#   library_id = data.vsphere_content_library.library.id
# }

resource "vsphere_virtual_machine" "vm" {
  count            = var.num_esxi_hosts
  name             = "${var.nameprefix}${format("%04d", count.index + var.offset)}"
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  #   folder = "terraform"
  #   datacenter_id = data.vsphere_datacenter.datacenter.id
  #   host_system_id = data.vsphere_host.host.id
  num_cpus                   = 2
  memory                     = 4096
  wait_for_guest_net_timeout = 0
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  
  disk {
    label            = "sda"
    unit_number      = 0
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  disk {
    label            = "sdb"
    unit_number      = 1
    size             = data.vsphere_virtual_machine.template.disks.1.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.1.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.1.thin_provisioned
  }

  disk {
    label            = "sdc"
    unit_number      = 2
    size             = data.vsphere_virtual_machine.template.disks.2.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.2.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.2.thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  vapp {
    properties = {
      "guestinfo.hostname"   = "${var.nameprefix}${format("%04d", count.index + var.offset)}",
      "guestinfo.ipaddress"  = "0.0.0.0",
      "guestinfo.netmask"    = "",
      "guestinfo.gateway"    = "",
      "guestinfo.dns"        = "",
      "guestinfo.domain"     = "",
      "guestinfo.ntp"        = "us.pool.ntp.org",
      "guestinfo.password"   = "${var.esxi_root_password}",
      "guestinfo.ssh"        = "True",
      "guestinfo.createvmfs" = "False",
      "guestinfo.debug"      = "False"
    }
  }
  lifecycle {
    ignore_changes = [
      annotation,
      vapp[0].properties,
    ]
  }
}