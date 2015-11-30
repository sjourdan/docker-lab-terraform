# Configure the DigitalOcean Provider
provider "digitalocean" {
    token = "${var.do_token}"
}

# Configure the SSH Key
resource "digitalocean_ssh_key" "docker-lab-key" {
    name = "Docker Lab Key"
    public_key = "${file("${var.do_ssh_key_file}.pub")}"
}

# Create a node
resource "digitalocean_droplet" "docker" {
  count = "${var.num_servers}"
  image = "${var.do_image}"
  name = "docker-lab-${count.index+1}"
  region = "${var.do_region}"
  size = "${var.do_size}"
  ssh_keys = [ "${digitalocean_ssh_key.docker-lab-key.id}" ]
  user_data = "${file("cloud-config.yml")}"

  connection {
    user = "root"
    key_file = "${var.do_ssh_key_file}"
  }

  provisioner "remote-exec" {

    inline = [
      "apt-get update && apt-get dist-upgrade -y",
      "curl -sSL https://get.docker.com/ | sh"
    ]

  }
}
