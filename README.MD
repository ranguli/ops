
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
export MINIO_ENDPOINT="http://myendpoint"
export MINIO_ACCESS_KEY="1234"
export MINIO_SECRET_KEY="1234"
terraform plan
terraform apply
```


### MinIO Client Installation



```
mc alias set minio http://server:9000 access_key secret_key
```
