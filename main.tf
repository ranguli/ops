module "image-bucket" {
  source = "./modules/data-stores/image-bucket"
  minio_bucket_name = var.minio_bucket_name
  minio_server = var.minio_server
  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key
}
