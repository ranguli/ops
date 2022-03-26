terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.6.14"
    }
  }
}

module "debian_bullseye" {
  source = "../base/debian/bullseye"
}

resource "libvirt_volume" "harbor" {
  name   = "harbor.qcow2"
  base_volume_id = module.debian_bullseye.volume_id
}

resource "libvirt_domain" "harbor" {
  name     = "harbor"
  memory = "2048"

  disk {
    volume_id = libvirt_volume.harbor.id
  }
}
