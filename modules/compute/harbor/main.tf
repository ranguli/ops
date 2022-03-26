terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.6.14"
    }
  }
}

module "debian_bullseye" {
  source = "../base-images/debian/bullseye"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

resource "libvirt_volume" "harbor" {
  name = var.name
  base_volume_id = module.debian_bullseye.volume_id
}

resource "libvirt_domain" "harbor" {
  name     = var.name
  memory = "2048"
  cloudinit = libvirt_cloudinit_disk.commoninit.id

  disk {
    volume_id = libvirt_volume.harbor.id
  }
}
