
// JUMPBOX
variable "jumpbox_ip" {
  default = "123.234.345.456" //CHANGEME
  description = "Jumpbox IP - Every ssh connection goes through this jumpbox, this is the only exposed ssh port"
}
variable "ssh_private_key" {
  default = "~/.ssh/id_rsa_terraform" 
  description = "ssh private key"
}


// WHITELISTS (using ferm)
variable "trusted_ips" {
  default = "192.168.0.0/24 192.168.1.1" //CHANGEME
  description = "http(s) whitelist for module 'server-digitalocean-https', to whitelist your VPN range and such"
}
variable "azure_cdn_ips" {
  default = "5.104.64.0/21 46.22.64.0/20 61.221.181.64/26 68.232.32.0/20 72.21.80.0/20 88.194.45.128/26 93.184.208.0/20 101.226.203.0/24 108.161.240.0/20 110.232.176.0/22 117.18.232.0/21 117.103.183.0/24 120.132.137.0/25 121.156.59.224/27 121.189.46.0/23 152.195.0.0/16 180.240.184.0/24 192.16.0.0/18 192.30.0.0/19 192.229.128.0/17 194.255.210.64/26 198.7.16.0/20 203.74.4.64/26 213.64.234.0/26 213.65.58.0/24 68.140.206.0/23 68.130.0.0/17 152.190.247.0/24 65.222.137.0/26 65.222.145.128/26 65.198.79.64/26 65.199.146.192/26 65.200.151.160/27 65.200.157.192/27 68.130.128.0/24 68.130.136.0/21 65.200.46.128/26 213.175.80.0/24 152.199.0.0/16 36.67.255.152/29 194.255.242.160/27 195.67.219.64/27 88.194.47.224/27 203.66.205.0/24"
  description = "Azure CDN IP range (@TODO link to reference)"
}
variable "fastly_cdn_ips" {
  default = "23.235.32.0/20 43.249.72.0/22 103.244.50.0/24 103.245.222.0/23 103.245.224.0/24 104.156.80.0/20 151.101.0.0/16 157.52.64.0/18 167.82.0.0/17 167.82.128.0/20 167.82.160.0/20 167.82.224.0/20 172.111.64.0/18 185.31.16.0/22 199.27.72.0/21 199.232.0.0/16"
  description = "Fastly CDN IP range (https://api.fastly.com/public-ip-list)"
}

// COBALT STRIKE
variable "cobalt-strike-license" {
  default = "1337-CHANGEME-1337"
  description = "Cobalt Strike license"
}
variable "cobalt-strike-pass" {
  default = "CHANGEME"
  description = "Cobalt Strike password"
}
variable "cobalt-strike-profile" {
  default = ""
  description = "Cobalt Strike profile to use (can be blank)"
}

// DIGITAL OCEAN
variable "do_ssh_keys" {
  default = [313373] //CHANGEME
  description = "Digital Ocean key IDs"
}
variable "do_default_size" {
  default = "s-1vcpu-1gb" # 5$="[s-1vcpu-1gb"] 10$=["s-1vcpu-2gb"] 15$=["s-1vcpu-3gb","s-2vcpu-2gb"] 20$=["s-2vcpu-4gb"]
}
variable "do_default_region" {
  default = "tor1"
}
variable "do_default_image" {
  default = "debian-9-x64" //also used: [ "ubuntu-18-04-x64" ]
}


// DOMAINS
variable "do_default_domain" {
  default = "CHANGEME.com"
  description = "make sure you have this one registered in Digital Ocean"
}
variable "do_fast_update_domain_for_azure_front" {
  default = "CHANGEME.com"
  description = "will use a 'do_fast_update_domain_for_azure_front' subdomain with short TTL between the azure domain front to speed up CDN Endpoint updates"
}



// DELIVERY
variable "pwndrop_admin_password" {
  default = "CHANGEME"
  description = "make sure you have this one registered in Digital Ocean"
}
variable "pwndrop_secret_url" {
  default = "pwndrop_secret_url_CHANGEME"
  description = "will use a 'do_fast_update_domain_for_azure_front' subdomain with short TTL between the azure domain front to speed up CDN Endpoint updates"
}
