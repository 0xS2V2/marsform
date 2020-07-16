variable "name" { }

variable "do_image" { default = "" }
variable "do_size" { default = "" }
variable "do_region" { default = "" }

variable "redir_c2_ip" { default = "" }


output "ip" { value = digitalocean_droplet.core.ipv4_address }

output "ssh_config" {
  value = "\n\nHost ${var.name}\n    Hostname      ${digitalocean_droplet.core.ipv4_address}\n    User          root\n    ProxyJump     jumpbox"
}