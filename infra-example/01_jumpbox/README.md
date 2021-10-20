
# Jumpbox

The only exposed ssh port is the jumpbox, every other machine uses an "ssh jump" through this jumpbox.

```
                                                       |
                       Private                         |            Internet
                      ---------                        |           ----------
                                                       |
                                                       |
                                                       |     +-----------------+
                                                       |     |                 |
     ssh port forward to access teamserver, ssh, etc.  |     |     Jumpbox     |   ssh    +----------+
  +----------------------------------------------------+-----| (port 22 open)  |<---------| Attacker |
  |                                                    |     |(permanent infra)|          +----------+
  |                                                    |     |                 |
  |                                                    |     +-----------------+
  |                                                    |
  |                                                    |
  |              +----------------------+              |
  |              |                      |              |
  |              |   +--------------+   |     +--------+-----------+
  |              |   |              |   +---->|                    |             +----------+
  +--------------+-->|  TeamServer  |<--------|    HTTPS Redir     |<------------|  Victim  |
                     |              |         |                    |             +----------+
                     +--------------+         +-+------------------+
                                                       |
                                                       |
                                                       |
                                                       |
                                                       |
                                                       v
```

## 1) Review the `jumpbox.tf`

- Make sure the jumpbox name is good

## 2) Review the `core.sh` script

This script will run on every droplet and will:

- Install the basic tools, software
- Restrict the firewall to listen only

## 3) Deploy the jumpbox

Initialze the modules, then deploy the droplet.

```
terraform init
terraform apply
```

The output will show the ssh config; you can copy it manually in `~/.ssh/config` or use the optionnal configuration to include the generated files automatically. (recommended for dev only)

## 4) (Optionnal) Import the ssh key automatically

Add this to your `~/.ssh/config` file (adjust the path):

```
Include ~/tools/marsform/ssh_config/*
```

## 5) Adjust the `JUMPBOX` section in `global.tf`

- Set the `jumpbox_ip` variable (a jumpbox where you can ssh with a private key)

### Examples

Example of a jumpbox configuration:
```
Host jumpbox
    Hostname      178.128.226.175
    User          root
```

Example of ssh connection to the jumpbox: `ssh jumpbox`
