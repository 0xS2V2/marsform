
# HTTPS Redirector

## 1) Review the `redirector.tf`

- Make sure the name is good

Optionnally:

- Set a domain (buy a domain, point it to Digital Ocean nameservers, and set the `domain` variable)
- Spoof a website (set the `spoofed_website` variable)

## 2) Review the `apache-https.sh` script

This script will install apache2, configure the vhost, install apache modules, etc.

## 3) Deploy the redirector

```
terraform init
terraform apply
```

## 4) After the c2 is deployed, adjust the proxypass so it points to the teamserver

### Examples

Example of a https server configuration:
```
Host https-server
    Hostname      178.128.226.175
    User          root
    ProxyJump     jumpbox
```

Example of ssh connection to the jumpbox: `ssh https-server`
