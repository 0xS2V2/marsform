
module "http-server" {
  source = "../../modules/server-digitalocean-fiercephish"
  # in Digital Ocean, the name must be the domain for the reverse DNS
  name   = "test-phishing-server"
  domain = "googlegoogle.com"

  # optionnal
  #size   = "s-1vcpu-1gb"
  #region = "tor1"
  # the image must be "ubuntu-18-04-x64" for this version of fiercephish

  # copy paste the output dkim value here and re-apply
  dkim_value = ""
}

output "SSH_Config" { value = module.http-server.ssh_config }
