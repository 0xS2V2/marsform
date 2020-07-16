
module "azure_domain_front" {
  source = "../../modules/front-azure"
  front_name = var.front_name
  front_redirect = "front-${var.front_name}.${var.do_fast_update_domain_for_azure_front}"
  redir_ip = var.front_redirect
}

# Deploy only if "front_name" is set

resource "digitalocean_record" "front_domain_redir" {
  count = var.front_name == "" ? 0 : 1

  domain = var.do_default_domain
  name = "front-${var.front_name}"
  value = var.front_redirect
  type = "A"
  ttl = 30
}
