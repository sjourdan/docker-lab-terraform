# outputs all public IPv4 addresses
output "ip_addresses" {
  value = "${join(",", digitalocean_droplet.docker.*.ipv4_address)}"
}
