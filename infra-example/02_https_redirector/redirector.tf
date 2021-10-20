
module "http-server" {
  source        = "../../modules/server-digitalocean-https"
  name          = "test-redirector"

  # optionnal
  #size   = "s-1vcpu-1gb"
  #region = "tor1"
  #image  = "ubuntu-18-04-x64"

  #domain = ""
  #spoofed_website = "https://google.ca"
}

output "SSH_Config" { value = module.http-server.ssh_config }
