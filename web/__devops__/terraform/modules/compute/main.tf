resource "digitalocean_ssh_key" "default" {
  name = "egal"
  public_key = var.public_key
}

# DigitalOcean box sizes:
# https://developers.digitalocean.com/documentation/v2/#list-all-sizes

resource "digitalocean_droplet" "backend" {
  image = "ubuntu-20-04-x64"
  name = "egal0${count.index+1}-nyc1"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  size = "s-1vcpu-1gb"
  region = "nyc1"
  count = 1
  tags = ["sandbox"]
}
