
resource "digitalocean_droplet" "core" {
  name = var.name
  size = var.do_size != "" ? var.do_size : var.do_default_size
  image = var.do_image != "" ? var.do_image : var.do_default_image
  region = var.do_region != "" ? var.do_region : var.do_default_region
  ssh_keys = var.do_ssh_keys

  connection {
	  host = self.ipv4_address
	  bastion_host = var.jumpbox_ip
  }

  provisioner "remote-exec" {
    inline = [
        "mkdir -p /etc/ferm/ferm.d/",
        "echo 'table filter chain INPUT proto tcp dport (22) saddr (${var.jumpbox_ip}) ACCEPT;' > /etc/ferm/ferm.d/jumpbox.conf"
    ]
  }

  provisioner "remote-exec" {
    scripts = [
      "../../scripts/core.sh"
    ]
  }
}

resource "null_resource" "ssh_config" {
  depends_on = [digitalocean_droplet.core]

  triggers = {
    name = var.name
  }

  provisioner "local-exec" {
    command = "echo 'Host ${var.name}\n    Hostname      ${digitalocean_droplet.core.ipv4_address}\n    User          root\n    ProxyJump     jumpbox' > ../../ssh_configs/config_${self.triggers.name}"
  }

  provisioner "local-exec" {
    when = destroy
    command = "rm -f ../../ssh_configs/config_${self.triggers.name}"
  }
}
