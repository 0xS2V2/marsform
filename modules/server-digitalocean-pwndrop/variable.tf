variable "name" { }

variable "do_size" { default = "" }

variable "azure_domain_front" { default = "" }
variable "do_azure_front_fast_update_domain" { default = "" }


output "ip" { value = module.core.ip }

#output "ssh_config" { value = module.core.ssh_config }

output "ssh_config" { value = "${module.core.ssh_config}\n# Pwndrop: https://${module.core.ip}/${trimprefix(var.pwndrop_secret_url, "/")}   pass: ${var.pwndrop_admin_password}" }
