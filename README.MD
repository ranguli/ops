
## Prerequisites

Any Linux distribution should make for a suitable hypervisor / VM host as long as it can
run the following:
- MinIO
- QEMU/KVM
- Libvirt

Infrastructure can be built and deployed from any development machine as long
as it can run:
- Terraform
- Packer
- QEMU/KVM
- MinIO client (`mc`)

```
export LIBVIRT_DEFAULT_URI="qemu+ssh://gentoo@192.168.2.24/system"
terraform plan
terraform apply
```

## Setup

```bash
terraform init
````
