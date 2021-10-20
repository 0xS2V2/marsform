# Marsform (Terraform for RedTeamers)

## Introduction

Marsform is a RedTeam infrastructure deployment tool based on [Terraform](https://www.terraform.io/).

The goal is to deploy a secure infrastructure as fast as possible.

A simplified tutorial is available in [infra-examples](infra-examples)

## Setup

Digital Ocean and Azure (mostly) are used in this setup, but any provider could be used.

- The only exposed ssh port is the jumpbox, every other machine uses an "ssh jump" through this jumpbox.
- The firewalls are managed with [ferm](http://ferm.foo-projects.org/)
  - teamservers are accessible through ssh port forward
- The `global.tf` in the root folder contains all the global variables that might be needed in any module.


###  1) Define your API Keys/Tokens.

Add this to your `.bashrc`

```
export DIGITALOCEAN_TOKEN="CHANGEME"
export ARM_SUBSCRIPTION_ID="CHANGEME"
export FASTLY_API_KEY="CHANGEME"
```

### 2) Install providers dependencies (if you plan to deploy in Azure)

Install `azure-cli`. Make sure you run `az login` before deploying in Azure.


### 3) Adjust the Global Varibales file `global.tf`

- Set the `jumpbox_ip` variable (a jumpbox where you can ssh with a private key)
- Set the `do_ssh_keys` variable (a comma separated list of ssh key fingerprints) : ```curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DIGITALOCEAN_TOKEN}" "https://api.digitalocean.com/v2/account/keys" | grep -o '"id":[0-9]*'```



### 4) Create missing files

Initial jumpbox config; the generated `ssh_config` will use 'jumpbox' as ProxyJump.

Make sure you have a 'jumpbox' entry in your `~/.ssh/config`:
```
Host jumpbox
  User root
  Hostname 159.263.323.317
```

Cobalt Strike archive IS NOT provided; if you plan to deploy a Cobalt Strike teamserver, download it with your license and copy it there:
- `./files/cobaltstrike-dist.tgz`



### 5) Define your infrastructure and deploy

In the root directory of this project, adjust the content of `infra.tf` to reflect the infrastructure you wish to deploy.

You will then be able to `init` then `apply`:
```
terraform init
terraform apply
```


## Caveats

- Users **will** require port forward knowledge
- Most stuff runs as root :(
- When deploying a FiercePhish server, you must copy/paste the value from the FiercePhish installation output (saved in /tmp/fiercephish-install.out), then re-run `terraform apply`. (since the *mail._domainkey* key is generated during the installation)


### Typical Infrastructure Example

```
                                                       |
                       Private                         |            Internet
                      ---------                        |           ----------
                                                       |
                                                       |
                                                       |     +-----------------+
                                                       |     |                 |
     ssh port forward to access teamserver, ssh, etc.  |     |     Jumpbox     |   ssh    +----------+
  +----+-----+-----------------------+-----------------+-----| (port 22 open)  |<---------| Attacker |
  |          |                       |                 |     |(permanent infra)|          +----------+
  |          |                       |                 |     |                 |
  |          |                       |                 |     +-----------------+
  |          |                       |                 |
  |          |                       |                 |
  |          |                       |                 |
  |          v                       v                 |
  |  +--------------+        +---------------+         |    +-------------+
  |  |              |        |               |         |    |             |
  |  |  TeamServer  |<-------+  HTTPS Redir  |<--------+----|  Azure CDN  |<--------+
  |  |              |        |               |         |    |             |         |
  |  +--------------+        +---------------+         |    +-------------+         |
  |                                                    |                            |
  |                                                    |                            |
  |                     +----------------------+       |                            |
  |                     |                      |       |                            |
  |                     |   +--------------+   |     +-+------------------+         |
  |                     |   |              |   +---->|                    |         |
  |---------------------+-->|  TeamServer  |<--------|     DNS Redir      |<--------+
  |                         |              |         |                    |         |
  |                         +--------------+         +-+------------------+         |     +----------+
  |                                                    |                            |-----|  Victim  |
  |                                                    |                            |     +----------+
  |                   +-----------------------+        |    +-------------+         |
  |                   |                       |        |    |             |         |
  +------------------>|  Web Delivery Server  |<-------+----|  Azure CDN  |<--------+
  |                   |                       |        |    |             |         |
  |                   +-----------------------+        |    +-------------+         |
  |                                                    |                            |
  |                                                    |                            |
  |                                                  +-+------------------+         |
  |                                              ssh |                    |         |
  +------------------------------------------------->|  Phishing Server   |<--------+
                                                     |                    |
                                                     +-+------------------+
                                                       |
                                                       |
                                                       |
                                                       v
```

## Credits

Author: [S2V2](https://keybase.io/s2v2)

Inspired from:
- [@byt3bl33d3r](https://twitter.com/byt3bl33d3r)'s [Red Baron](https://github.com/Coalfire-Research/Red-Baron/) project
- [@_RastaMouse](https://twitter.com/_RastaMouse)'s [Automated Red Team Infrastructure Deployment with Terraform](https://rastamouse.me/2017/08/automated-red-team-infrastructure-deployment-with-terraform---part-1/) (and [part 2](https://rastamouse.me/2017/09/automated-red-team-infrastructure-deployment-with-terraform---part-2/)) blog posts.
- [@bluscreenofjeff](https://twitter.com/bluscreenofjeff)'s [Red Team Infrastructure Wiki](https://github.com/bluscreenofjeff/Red-Team-Infrastructure-Wiki)
- [@rsmudge](https://twitter.com/rsmudge)'s [Malleable-C2-Profiles](https://github.com/rsmudge/Malleable-C2-Profiles) repository
  - specifically [@harmj0y](https://twitter.com/harmj0y)'s [Amazon browsing traffic profile](https://github.com/rsmudge/Malleable-C2-Profiles/blob/master/normal/amazon.profile) used in this project
- [@ramen0x3f](https://twitter.com/ramen0x3f)'s [AggressorScripts](https://github.com/ramen0x3f/AggressorScripts) repository
- [@raikiasec](https://twitter.com/raikiasec)'s [FiercePhish](https://github.com/Raikia/FiercePhish) project
- [@mrgretzky](https://twitter.com/mrgretzky)'s [pwndrop](https://github.com/kgretzky/pwndrop) hosting file service
