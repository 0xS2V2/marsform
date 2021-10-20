
# Phishing Server

## 1) Review the `phishing.tf`

- Make sure the name is good; in Digital Ocean, the name must be the domain for the reverse DNS
- Set a domain (buy a domain, point it to Digital Ocean nameservers, and set the `domain` variable)

You can deploy/test without owning the domain but the spam score will be weak.

## 2) Review the `fiercephish.sh` script

This script will install fiercephish and open port 25.

## 3) Deploy the redirector

```
terraform init
terraform apply
```

## 4) Test the mail reputation

After the phishing server is deployed, you can test the reputation using https://www.mail-tester.com/.

DNS records often take time to propagate.

### Examples

Example of a https server configuration:
```
Host phishing-server
    Hostname      178.128.226.175
    User          root
    ProxyJump     jumpbox
    LocalForward  8080 127.0.0.1:80
```

Example of ssh connection to the jumpbox: `ssh phishing-server`

Then access the app using `https://localhost:8080`
