
resource "digitalocean_droplet" "core" {
  name = "jumpbox"
  size = var.do_default_size
  image = var.do_default_image
  region = var.do_default_region
  ssh_keys = var.do_ssh_keys

  connection {
	  host = self.ipv4_address
  }

  provisioner "local-exec" {
    command = "echo 'Host ${self.name}\n    Hostname      ${self.ipv4_address}\n    User          root' > ../../ssh_configs/jumpbox"
  }
  provisioner "local-exec" {
    when = destroy
    command = "rm -f ../../ssh_configs/jumpbox"
  }

  provisioner "remote-exec" {
    inline = [
        "mkdir -p /etc/ferm/ferm.d/",
        "echo 'table filter chain INPUT proto tcp dport (22) ACCEPT;' > /etc/ferm/ferm.d/jumpbox.conf"
    ]
  }

  provisioner "remote-exec" {
    scripts = [
      "../../scripts/core.sh"
    ]
  }
}

output "SSH_Config" {
  value = "\nHost ${digitalocean_droplet.core.name}\n    Hostname      ${digitalocean_droplet.core.ipv4_address}\n    User          root\n"
}