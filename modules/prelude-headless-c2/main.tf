
resource "null_resource" "install-prelude-headless" {
  connection {
    host = var.server_ip
    bastion_host = var.jumpbox_ip
  }


  provisioner "file" {
    source      = "${path.module}/files/prelude-headless.service"
    destination = "/etc/systemd/system/prelude-headless.service"
  }


  provisioner "remote-exec" {
    inline = [
      "apt-get install -y wget p7zip-full",
      "mkdir prelude-headless",
      "cd prelude-headless",
      "wget 'https://download.prelude.org/latest?arch=x64&platform=linux&variant=zip&edition=headless' -O prelude-headless-linux-latest.zip",
      "7z x prelude-headless-linux-latest.zip",
    ]
  }

  provisioner "file" {
    content      = templatefile("${path.module}/files/start_prelude_headless.sh.tmpl", { ACCOUNT_EMAIL = var.accountEmail, SESSION_TOKEN = var.sessionToken })
    destination = "/root/prelude-headless/start_prelude_headless.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /root/prelude-headless/start_prelude_headless.sh",
      "systemctl enable prelude-headless",
      "systemctl start prelude-headless",
      "sleep 10",
      "sed -i 's/abcdefghijklmnopqrstuvwxyz012345/${var.secretKey}/g' /root/prelude-headless/workspace/portal.prelude.org/settings.yml",
      "systemctl restart prelude-headless.service",
    ]
  }
}


resource "null_resource" "ferm" {
  depends_on = [ null_resource.install-prelude-headless ]
  connection {
    host = var.server_ip
	  bastion_host = var.jumpbox_ip
  }

  provisioner "remote-exec" {
    inline = [
        "echo 'table filter chain INPUT proto tcp dport (50051) ACCEPT;' > /etc/ferm/ferm.d/grpc.conf",
        "systemctl reload ferm"
    ]
  }
}

output "server_ip" {
  value = var.server_ip
}

output "sessionToken" {
  value = var.sessionToken
}
