variable "name" { }
variable "do_image" { default = "" }
variable "do_size" { default = "" }
variable "do_region" { default = "" }

variable "accountEmail" { description = "Prelude accountEmail variable" }
variable "sessionToken" { description = "Prelude headless session token" }
variable "secretKey" { description = "Prelude encryption key" }

output "ip" { value = module.core.ip }
output "ssh_config" { value = module.core.ssh_config }
output "sessionToken" { value = var.sessionToken }
