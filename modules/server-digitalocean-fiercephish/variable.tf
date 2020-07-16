variable "name" { }

variable "do_size" { default = "" }

variable "domain" { }
variable "register_domain" { default = "" }
variable "dkim_value" { default = "" }

variable "fiercephish_admin_passwd" { default = "default_admin_pass_38f52d62" }
variable "fiercephish_mysql_passwd" { default = "default_mysql_pass_9fe4f630" }

output "ip" { value = module.core.ip }

output "ssh_config" { value = module.core.ssh_config }