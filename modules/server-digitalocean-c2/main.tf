
module "core" {
  source = "../server-digitalocean-core"
  name = var.name // characters are allowed: (a-z, A-Z, 0-9, . and -)
  do_size = var.do_size != "" ? var.do_size : "s-1vcpu-2gb" # minumum for a teamserver
}

module "c2" {
  source = "../cobaltstrike-c2"
  c2_ip = module.core.ip
  # Optionnal
  local_proxy = var.local_proxy
  aggressor   = var.aggressor
}