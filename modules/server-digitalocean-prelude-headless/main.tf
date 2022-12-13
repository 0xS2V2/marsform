
module "core" {
  source = "../server-digitalocean-core"
  name = var.name // characters are allowed: (a-z, A-Z, 0-9, . and -)
  do_size = var.do_size != "" ? var.do_size : ""
  do_image = var.do_image != "" ? var.do_image : ""
  do_region = var.do_region != "" ? var.do_region : ""
}

module "c2" {
  depends_on = [module.core]
  source = "../prelude-headless-c2"
  server_ip = module.core.ip
  accountEmail = var.accountEmail
  sessionToken = var.sessionToken
  secretKey    = var.secretKey
}
