terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# libvirt_pool to specify where the volume will reside
resource "libvirt_pool" "pool-1" {
  name = "pool-1"
  type = "dir"
  target {
    path = "/mnt/data/libvirt_pool_1"
  }
}

# resource "libvirt_network" "default" {
#   name = "default"
#   mode = "nat"
#   autostart = true
#   addresses = ["192.168.101.1/24"]  # Gateway address and subnet for network

#   dhcp {
#     enabled = true
#   }
# }

locals {
  vm_names = ["talos-1", "talos-2"]
}

resource "libvirt_volume" "vm_disk" {
  for_each = toset(local.vm_names)
  name     = "vm-disk-${each.key}.qcow2"
  pool     = libvirt_pool.pool-1.name
  format   = "qcow2"
  size     = 25 * 1024 * 1024 * 1024  # 25 GiB
}

resource "libvirt_domain" "vm" {
  for_each = toset(local.vm_names)
  name     = each.key
  memory   = 8192
  vcpu     = 4
  qemu_agent = true
#   autostart  = true

  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = libvirt_volume.vm_disk[each.key].id
  }
  disk {
    file = "/home/uri/Documents/talos-metal-amd64.iso"
  }
#   depends_on = [libvirt_network.default]
  boot_device {
    dev = ["cdrom", "hd", "network"]  # boot from cdrom first, then hd, then network
  }
}



# # libvirt_volume for VM
# resource "libvirt_volume" "vm_disk_1" {
#   name = "vm-disk-1.qcow2"
#   pool = "pool-1"
#   format = "qcow2"
#   size   = 25 * 1024 * 1024 * 1024  # 10 GiB
# }

# # the VM
# resource "libvirt_domain" "talos-1" {
#   name = "talos-1"
#   memory = "8192"
#   vcpu   = 4
#   qemu_agent = true
#   autostart = true
#   network_interface {
#     network_name = "default"
#   }
#   disk {
#     volume_id = libvirt_volume.vm_disk_1.id
#   }
#   disk {
#     file = "/home/uri/Documents/talos-metal-amd64.iso"
#   }
# }