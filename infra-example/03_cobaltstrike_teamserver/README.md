
# CobaltStrike Teamserver

## 1) Review the `redirector.tf`

- Make sure the name is good
- Set the `redir_ip` variable

## 2) Review the `cobaltstrike.sh` script

This script will install cobaltstrike and setup a systemctl service.

## 3) Provide the Cobalt Strike archive

Place the archive in `modules/cobaltstrike-c2/files/cobaltstrike-dist.tgz"`.
Make sur to keep the same structure as the original.

## 4) (Optionnal) Review the `cobaltstrike-aggressor.sh` script

This script will create a headless aggressor script and start it with a systemctl service.

## 5) Deploy the redirector

```
terraform init
terraform apply
```

### Examples

Example of a teamserver configuration with local port forward on port 31337:
```
Host teamserver
    Hostname      143.198.33.121
    User          root
    ProxyJump     jumpbox
    LocalForward  31337 127.0.0.1:50050
```

Example of ssh connection to the jumpbox: `ssh teamserver`
