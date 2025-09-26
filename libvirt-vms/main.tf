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

resource "libvirt_domain" "talos-1" {
  name = "talos-1"
  memory = "8192"
  vcpu   = 4
  qemu_agent = true
  autostart = true
}

resource "libvirt_pool" "pool-1" {
  name = "pool-1"
  type = "dir"
  target {
    path = "/mnt/data/libvirt_pool_1"
  }
}