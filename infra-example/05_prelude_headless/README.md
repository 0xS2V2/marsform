
# Prelude Headless

## 1) Review the `prelude-headless.tf`

- Make sure the name is good
- Set the `accountEmail`; this is can be seen in Connect -> Deploy Redirectors
- Set the `sessionToken` variable; this is used to link the Operator session
- Set the `secretKey` variable; this an AES Encryption keys, it has to match one of the the Operator "Encryption Keys" (in Settings -> General)

## 2) Deploy the redirector

```
terraform init
terraform apply
```

The redirector IP and Token will appear as output variables after the deployment.

## 3) Create and configure a redirector in Operator

- Go to Connect -> Deploy Redirectors, enter the IP and Token of the Redirector (from the output variables), then click Provision.
- Click on the newly created redirectors, on the right side of the screen.
- Click Connect, at the bottom of the screen.

Operator should promt "You are connected to <server_ip>" and the indicator turns green.

### Examples

Example of a prelude-headless SSH configuration:
```
Host headless
    Hostname      143.198.33.121
    User          root
    ProxyJump     jumpbox
```

Example of ssh connection to the jumpbox: `ssh headless`
