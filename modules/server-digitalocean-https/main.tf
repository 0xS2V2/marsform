
module "core" {
  source = "../server-digitalocean-core"
  name = var.name // characters are allowed: (a-z, A-Z, 0-9, . and -)
  do_size = var.do_size != "" ? var.do_size : ""
  do_image = var.do_image != "" ? var.do_image : ""
  do_region = var.do_region != "" ? var.do_region : ""
}

resource "null_resource" "http" {
  depends_on = [ module.core ]
  connection {
	  host = module.core.ip
	  bastion_host = var.jumpbox_ip
  }

  provisioner "remote-exec" {
    scripts = [
      "../../scripts/apache-https.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = [
        "echo 'table filter chain INPUT proto tcp dport (80 443) ACCEPT;' > /etc/ferm/ferm.d/https.conf",
        "systemctl reload ferm"
    ]
  }
}

# Spoof a website if "spoofed_website" parameter is set
resource "null_resource" "spoofed_website" {
  count = var.spoofed_website == "" ? 0 : 1
  depends_on = [ null_resource.http ]

  connection {
    host = module.core.ip
    bastion_host = var.jumpbox_ip
  }

  provisioner "remote-exec" {
    inline = [
        "echo '# Spoof Website'                                  >> /var/www/html/.htaccess",
        "echo 'RewriteRule (.*) ${var.spoofed_website}/$1 [P,L]' >> /var/www/html/.htaccess"
    ]
  }
}


resource "digitalocean_record" "domain" {
  depends_on = [ null_resource.http ]
  count = var.domain == "" ? 0 : 1

  domain = var.domain
  type = "A"
  name = "@"
  value = module.core.ip
}

resource "digitalocean_record" "domain-www" {
  depends_on = [ null_resource.http ]
  count = var.domain == "" ? 0 : 1

  domain = var.domain
  type = "A"
  name = "www"
  value = module.core.ip
}


module "azure_domain_front" {
  source = "../front-azure"
  front_name = var.azure_domain_front
  front_redirect = module.core.ip
}

#module "fastly_domain_front" {
#  source = "../front-fastly"
#  front_name = var.fastly_domain_front
#  front_redirect = module.core.ip
#}