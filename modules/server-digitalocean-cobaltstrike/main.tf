
module "core" {
  source = "../server-digitalocean-core"
  name = var.name // characters are allowed: (a-z, A-Z, 0-9, . and -)
  do_size = var.do_size != "" ? var.do_size : ""
  do_image = var.do_image != "" ? var.do_image : ""
  do_region = var.do_region != "" ? var.do_region : ""
}

module "c2" {
  depends_on = [module.core]
  source = "../cobaltstrike-c2"
  c2_ip = module.core.ip
  redir_ip = var.redir_ip
  name = var.name
  # Optionnal
  local_proxy = var.local_proxy
  aggressor   = var.aggressor
  # Listener
  listener_url =  var.listener_url
  listener_beacons = var.listener_beacons
}
