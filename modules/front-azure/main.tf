
# Deploy only if "front_name" is set

resource "azurerm_resource_group" "front" {
    count = var.front_name == "" ? 0 : 1

    name = "${var.front_name}-redirector-group"
    location = "canadaeast"
}

resource "azurerm_cdn_profile" "front" {
    count = var.front_name == "" ? 0 : 1

    name                = "${var.front_name}-cdn-profile"
    location            = azurerm_resource_group.front[count.index].location
    resource_group_name = azurerm_resource_group.front[count.index].name
    sku                 = "Standard_Verizon"
}

resource "azurerm_cdn_endpoint" "front" {
    count = var.front_name == "" ? 0 : 1

    name                = var.front_name
    profile_name        = azurerm_cdn_profile.front[count.index].name
    location            = azurerm_resource_group.front[count.index].location
    resource_group_name = azurerm_resource_group.front[count.index].name
    origin {
        name      = var.front_name
        host_name = var.front_redirect
    }
}


resource "null_resource" "ferm_whitelist" {
  connection {
      host = var.redir_ip == "" ? var.front_redirect : var.redir_ip
      bastion_host = var.jumpbox_ip
      private_key = file(var.ssh_private_key)
  }

  provisioner "remote-exec" {
    inline = [
        "echo 'table filter chain INPUT proto tcp dport (80 443) saddr (${var.azure_cdn_ips}) ACCEPT;' > /etc/ferm/ferm.d/http_azure_cdn_ips.conf",
        "systemctl reload ferm"
    ]
  }
}
