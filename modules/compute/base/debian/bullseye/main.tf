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
  source = "./build/bullseye-329d9762-52c1-40ac-b0fd-2f6b9898695d.qcow2"
}
