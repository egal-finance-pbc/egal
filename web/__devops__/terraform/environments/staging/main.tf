variable "environment" { default = "staging" }

provider "digitalocean" {
}

module "project" {
  source = "../../modules/project"
}
