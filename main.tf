terraform {
  backend "s3" {
    bucket = "remote-state"
    endpoint = "http://192.168.2.24:9000"
    key = "terraform.tfstate"
    region = "main"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
    force_path_style = true
  }
}

module "harbor" {
  name = "harbor"
  source = "./modules/compute/harbor"
}
