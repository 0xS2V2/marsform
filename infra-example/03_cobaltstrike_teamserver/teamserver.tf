
module "teamserver" {
  source   = "../../modules/server-digitalocean-cobaltstrike"
  name     = "test-teamserver"
  redir_ip = "147.182.151.210"

  # optionnal
  #size   = "s-1vcpu-1gb"
  #region = "tor1"
  #image  = "ubuntu-18-04-x64"

  #local_proxy = "50050"
  #aggressor = 0

  #listener
  #listener_url = "" # host used for stagers
  #listener_beacons = "" # comma separated list of beacons
}

output "SSH_Config" { value = module.teamserver.ssh_config }
