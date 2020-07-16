
module "core" {
  source = "../server-digitalocean-core"
  name = var.name // characters are allowed: (a-z, A-Z, 0-9, . and -)
  do_size = var.do_size != "" ? var.do_size : ""
}

resource "null_resource" "http" {
  connection { 
	  host = module.core.ip
	  bastion_host = var.jumpbox_ip
	  private_key = file(var.ssh_private_key)
  }

  provisioner "remote-exec" {
    inline = [
        "curl https://raw.githubusercontent.com/kgretzky/pwndrop/master/install_linux.sh | bash",
        "echo 'Wait 5 seconds for pwndrop to start...'",
        "until [ -f /usr/local/pwndrop/pwndrop.ini ]; do sleep 1; done",
        "echo 'Editing configuration file...'",
        "echo '[setup]'                                                   >> /usr/local/pwndrop/pwndrop.ini",
        "echo 'username = admin'                                          >> /usr/local/pwndrop/pwndrop.ini",
        "echo 'password = ${var.pwndrop_admin_password}'                  >> /usr/local/pwndrop/pwndrop.ini",
        "echo 'redirect_url = https://google.com'                         >> /usr/local/pwndrop/pwndrop.ini",
        "echo 'secret_path = /${trimprefix(var.pwndrop_secret_url, "/")}' >> /usr/local/pwndrop/pwndrop.ini",
        "ln -s /usr/local/pwndrop/pwndrop.ini /root/pwndrop.ini",
        "echo 'Restarting pwndrop...'",
        "systemctl restart pwndrop",
        "echo 'table filter chain INPUT proto tcp dport (80 443) ACCEPT;' > /etc/ferm/ferm.d/http.conf",
        "systemctl reload ferm"
    ]
  }
}

#module "azure_domain_front" {
#  source = "../front-azure-digitalocean-fast-update"
#  front_name = var.azure_domain_front
#  front_redirect = module.core.ip
#}
