
module "prelude-headless" {
  source       = "../../modules/server-digitalocean-prelude-headless"
  name         = "test-headless"
  accountEmail = "2a7e7bb7-7436-4dd6-ab71-57dfee710284@desktop.prelude.org"
  sessionToken = "cafecafe-cafe-cafe-cafe-cafecafecafe"
  secretKey    = "q329ijdk8793jd2873jd28073jd08327"
}

output "SSH_Config" { value = module.prelude-headless.ssh_config }

output "Redirector_IP" {
  value = module.prelude-headless.ip
}
output "Redirector_Token" {
  value = module.prelude-headless.sessionToken
}
