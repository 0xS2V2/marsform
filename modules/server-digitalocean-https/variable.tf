variable "name" { }

variable "do_size" { default = "" }

variable "c2_ip" { default = "" }
variable "spoofed_website" { default = "" }
variable "domain" { default = "" }

variable "azure_domain_front" { default = "" }
variable "do_azure_front_fast_update_domain" { default = "" }
variable "fastly_domain_front" { default = "" }


output "ip" { value = module.core.ip }

#output "ssh_config" { value = module.core.ssh_config }

output "ssh_config" { value = "${module.core.ssh_config}${var.azure_domain_front == "" ? "" : "\n# Azure Domain Front: https://${var.azure_domain_front}.azureedge.net" }${var.fastly_domain_front == "" ? "" : "\n# Fastly Domain Front: https://${var.fastly_domain_front}.global.prod.fastly.net" }" }
