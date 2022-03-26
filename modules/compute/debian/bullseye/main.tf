terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.6.14"
    }
  }
}

resource "libvirt_volume" "debian_bullseye" {
  name   = "debian"
  source = "./build/debian-45fe9f10-b000-490c-ae1a-9f9d29781e06.qcow2"
}

resource "libvirt_domain" "debian_bullseye" {
  name     = "debian"
  memory = "2048"

  disk {
    volume_id = libvirt_volume.debian_bullseye.id
  }
}
