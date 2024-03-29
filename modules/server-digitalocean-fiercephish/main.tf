
module "core" {
  source = "../server-digitalocean-core"
  name = var.name // characters are allowed: (a-z, A-Z, 0-9, . and -)
  do_image = "ubuntu-18-04-x64"
  do_size = var.do_size != "" ? var.do_size : ""
  do_region = var.do_region != "" ? var.do_region : ""
}

resource "null_resource" "smtp" {
  depends_on = [ module.core ]

  connection {
	  host = module.core.ip
	  bastion_host = var.jumpbox_ip
  }

  provisioner "remote-exec" {
    scripts = [
      "../../scripts/fiercephish.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = [ # Override some config variables and install FiercePhish
        "echo 'WEBSITE_DOMAIN=\"${var.domain}\"' >> ~/fiercephish.config",
        "echo 'EMAIL_DOMAIN=\"${var.domain}\"' >> ~/fiercephish.config",
        "echo 'ADMIN_PASSWORD=\"${var.fiercephish_admin_passwd}\"' >> ~/fiercephish.config",
        "echo 'MYSQL_ROOT_PASSWD=\"${var.fiercephish_mysql_passwd}\"' >> ~/fiercephish.config",
        "cat /tmp/fiercephish-install.sh | bash | tee /tmp/fiercephish-install.out"
    ]
  }

  provisioner "local-exec" {
    command = "echo '    LocalForward  ${var.local_proxy} 127.0.0.1:80' >> ../../ssh_configs/config_${var.name}"
  }
}


resource "digitalocean_domain" "register" {
  depends_on = [ null_resource.smtp ]
  name       = var.domain
  ip_address = module.core.ip
}


resource "digitalocean_record" "wildcard" {
  depends_on = [ digitalocean_domain.register ]
  domain = var.domain
  type = "A"
  name = "@"
  value = module.core.ip
}

resource "digitalocean_record" "www" {
  depends_on = [ digitalocean_domain.register ]
  domain = var.domain
  type = "A"
  name = "www"
  value = module.core.ip
}

resource "digitalocean_record" "mail" {
  depends_on = [ digitalocean_domain.register ]
  domain = var.domain
  type = "A"
  name = "mail"
  value = module.core.ip
}

resource "digitalocean_record" "mx" {
  depends_on = [ digitalocean_domain.register ]
  domain = var.domain
  type = "MX"
  name = "@"
  value = "mail.${var.domain}."
  priority = 10
}

resource "digitalocean_record" "spf" {
  depends_on = [ digitalocean_domain.register ]
  domain = var.domain
  type = "TXT"
  name = "@"
  value = "v=spf1 a mx a:mail.${var.domain} a:${var.domain} ip4:${module.core.ip} ~all"

  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}

resource "digitalocean_record" "dmark" {
  depends_on = [ digitalocean_domain.register ]
  domain = var.domain
  type = "TXT"
  name = "_dmarc"
  value = "text: v=DMARC1; p=none"
}

# @TODO AUTOMATE RECORD FOR mail._domainkey value. for now copy/paste the value from the FiercePhish installation output (saved in /tmp/fiercephish-install.out)
resource "digitalocean_record" "dkim" {
  count      = var.dkim_value == "" ? 0 : 1
  depends_on = [ digitalocean_domain.register ]
  domain = var.domain
  type = "TXT"
  name = "mail._domainkey"
  value = var.dkim_value
}
