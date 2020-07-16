# Deploy only if "front_name" is set

resource "fastly_service_v1" "c2_endpoints" {
    count = var.front_name == "" ? 0 : 1

    name  = var.front_name
    domain {
        name  = var.front_name
    }

    backend {
        name = "Domain Front"
        port = var.port
        address = var.front_redirect
        use_ssl = var.port == 80 ? false : true
        ssl_check_cert = var.port == 80 ? true : false
    }

    cache_setting {
        name = "Disable caching"
        action  = "pass"
    }

    force_destroy = true
}


resource "null_resource" "ferm_whitelist" {
    count = var.front_name == "" ? 0 : 1
    connection { 
      host = var.front_redirect
      bastion_host = var.jumpbox_ip
      private_key = file(var.ssh_private_key)
    }

    provisioner "remote-exec" {
    inline = [
        "echo 'table filter chain INPUT proto tcp dport (80 443) saddr (${var.fastly_cdn_ips}) ACCEPT;' > /etc/ferm/ferm.d/http_fastly_cdn_ips.conf",
        "systemctl reload ferm"
    ]
    }
}
