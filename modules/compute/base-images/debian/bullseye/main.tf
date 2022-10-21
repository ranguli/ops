terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.6.14"
    }
  }
}

resource "libvirt_volume" "debian_bullseye" {
  name   = "debian_bullseye"
  source = "https://cloud.debian.org/images/cloud/bullseye/20220310-944/debian-11-genericcloud-amd64-20220310-944.qcow2"
}
