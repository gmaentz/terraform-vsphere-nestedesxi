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

provider "vsphere" {
  version        = "1.22.0"
  user           = var.vcenter_user
  password       = var.vcenter_password
  vsphere_server = var.vcenter_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

# Data lookups for the source vCenter environment

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

# Create the Nested ESXi VMs
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
  # The following section uses the vApp properties to customize each nested ESXi host.
  # if variable 'useDHCP' is set to 'false', you must set the values for 'hostnetmask',
  # 'hostgateway', and 'hostipaddress'.
  vapp {
    properties = {
      "guestinfo.hostname"   = "${var.nameprefix}${format("%04d", count.index + var.offset)}",
      "guestinfo.ipaddress"  = var.useDHCP ? "0.0.0.0" : element(var.hostipaddress, count.index)
      "guestinfo.netmask"    = var.useDHCP ? var.emptystring : var.hostnetmask
      "guestinfo.gateway"    = var.useDHCP ? var.emptystring : var.hostgateway
      "guestinfo.dns"        = var.hostdnsservers
      "guestinfo.domain"     = var.hostdomainname
      "guestinfo.ntp"        = "us.pool.ntp.org"
      "guestinfo.password"   = var.esxi_root_password
      "guestinfo.ssh"        = "True"
      "guestinfo.createvmfs" = "False"
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

# The following resource will 'wait' for 180 seconds to allow the nested hosts
# to boot and receive an IP address.  The subsequent data lookup pulls the IP
# into tfstate so it can be used as an output.

resource "time_sleep" "wait_180_seconds" {
  depends_on = [vsphere_virtual_machine.vm]
  triggers = {
    change_in_hostcount = length(vsphere_virtual_machine.vm)
  }
  create_duration = "180s"
}
data "vsphere_virtual_machine" "vm" {
  depends_on    = [time_sleep.wait_180_seconds]
  count         = var.num_esxi_hosts
  name          = "${var.nameprefix}${format("%04d", count.index + var.offset)}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}