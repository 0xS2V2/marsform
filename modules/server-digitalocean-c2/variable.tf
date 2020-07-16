variable "name" { }

variable "do_size" { default = "" }

variable "local_proxy" { default = "50050" }

variable "aggressor" { default = 0 }


output "ip" { value = module.core.ip }

output "ssh_config" { value = "${module.core.ssh_config}\n    LocalForward  ${var.local_proxy} 127.0.0.1:50050" }
