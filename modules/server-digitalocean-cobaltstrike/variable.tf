variable "name" { }
variable "redir_ip" { default = "" }

variable "do_image" { default = "" }
variable "do_size" { default = "" }
variable "do_region" { default = "" }

variable "local_proxy" { default = "50050" }
variable "aggressor" { default = 0 }

variable "listener_url" { default = "" }
variable "listener_beacons" { default = "" }


output "ip" { value = module.core.ip }

output "ssh_config" { value = "${module.core.ssh_config}\n    LocalForward  ${var.local_proxy} 127.0.0.1:50050" }
