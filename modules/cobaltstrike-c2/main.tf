
resource "null_resource" "cobaltstrike" {
  connection { 
    host = var.c2_ip
    bastion_host = var.jumpbox_ip
    private_key = file(var.ssh_private_key)
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
    source      = "./files/cobaltstrike/cobaltstrike-dist.tgz"
    destination = "/root/cobaltstrike.tgz"
  }

  provisioner "file" {
    source      = "./files/cobaltstrike/cobaltstrike.service"
    destination = "/etc/systemd/system/cobaltstrike.service"
  }


  provisioner "remote-exec" {
    scripts = [ 
      "./scripts/cobaltstrike.sh" 
    ]
  }

  provisioner "local-exec" {
    command = "echo '    LocalForward  ${var.local_proxy} 127.0.0.1:50050' >> ./ssh_configs/config_${var.c2_ip}"
  }

}

# Install Headless Aggressor if "aggressor" parameter is set
resource "null_resource" "c2-aggressor" {
  count = var.aggressor == 0 ? 0 : 1
  depends_on = [ null_resource.cobaltstrike ]
  connection { 
    host = var.c2_ip
    bastion_host = var.jumpbox_ip
    private_key = file(var.ssh_private_key)
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
    source      = "./files/cobaltstrike/aggressor.service"
    destination = "/etc/systemd/system/aggressor.service"
  }

  provisioner "file" {
    source      = "./files/cobaltstrike/aggressor.cna"
    destination = "/root/aggressor/aggressor.cna"
  }

  provisioner "remote-exec" {
    scripts = [ 
      "./scripts/cobaltstrike-aggressor.sh" 
    ]
  }
}


#resource "null_resource" "c2-listener" {
#  #count = var.listener_url == 0 ? 0 : 1
#  depends_on = [ null_resource.c2-aggressor ]
# 
#  connection { 
#    host = var.c2_ip
#    bastion_host = var.jumpbox_ip
#    private_key = file(var.ssh_private_key)
#  }
#  
#  provisioner "file" {
#    content = templatefile("./files/cobaltstrike/listener.cna.tmpl", {
#                LISTENER_NAME    = "https"
#                LISTENER_URL     = var.listener_url
#                LISTENER_HOST    = var.listener_url
#                LISTENER_PORT    = 443
#                LISTENER_PAYLOAD = "windows/beacon_https/reverse_https"
#                LISTENER_BEACONS = var.listener_beacons == "" ? var.listener_url : var.listener_beacons
#              })
#    destination = "/tmp/listener-https.cna"
#  }
# 
#  provisioner "remote-exec" {
#    inline = [
#        "(cd /root/cobaltstrike; ./agscript 127.0.0.1 50050 'Listener-https' ${var.cobalt-strike-pass} /tmp/listener-https.cna)",
#    ]
#  }
#}