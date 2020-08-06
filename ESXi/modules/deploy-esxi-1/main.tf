provider "vsphere" {
  version        = "1.21.1"
  user           = "administrator@vsphere.local"
  password       = "RPTpass123!"
  vsphere_server = "192.168.169.35"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "raid10_gen7"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = "192.168.169.34/Resources"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = "192.168.169.34"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vmFromLocalOvf" {
  name = "esxi1.lab.local"
  #folder = "terraform"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id = data.vsphere_datastore.datastore.id
  datacenter_id = data.vsphere_datacenter.datacenter.id
  host_system_id = data.vsphere_host.host.id

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout = 0

  ovf_deploy {
    local_ovf_path = "C:\\Users\\frank\\OneDrive\\Documents\\Customer\\Hytrust\\Nested_ESXi6.7_Appliance_Template_v1.ova"
    disk_provisioning = "thin"
    ip_protocol          = "IPV4"
    ip_allocation_policy = "STATIC_MANUAL"
    ovf_network_map = {
        "VM Network" = data.vsphere_network.network.id
    }
  }

  vapp {
    properties = {
      "guestinfo.hostname" = "esxi1.lab.local",
      "guestinfo.ipaddress" = "192.168.169.50",
      "guestinfo.netmask" = "255.255.255.0",
      "guestinfo.gateway" = "192.168.169.1",
      "guestinfo.dns" = "192.168.169.1",
      "guestinfo.domain" = "lab.local",
      "guestinfo.ntp" = "us.pool.ntp.org",
      "guestinfo.password" = "RPTpass123!",
      "guestinfo.ssh" = "True"
    }
  }
}