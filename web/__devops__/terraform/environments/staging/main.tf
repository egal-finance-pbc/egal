variable "EGAL_DIGITALOCEAN_TOKEN" {
  type = string
}

variable "environment" {
  default = "staging"
}

provider "digitalocean" {
  token = var.EGAL_DIGITALOCEAN_TOKEN
}

module "compute" {
  source = "../../modules/compute"
  environment = var.environment
  public_key = file("./egal_rsa.pub")
}
