
cat <<EOF>/usr/local/pwndrop/pwndrop.ini
[pwndrop]
admin_dir  = /usr/local/pwndrop/admin
listen_ip  = 
http_port  = 80
https_port = 443
data_dir   = /usr/local/pwndrop/data

[setup]                                     # optional: put in if you want to pre-configure pwndrop (section will be deleted from the config file on first run)
username = "admin"                          # username of the admin account
password = "secretpassword"                 # password of the admin account, overriden by the password in "global.tf"
redirect_url = "https://www.somedomain.com" # URL to which visitors will be redirected to if they supply a path, which doesn't point to any shared file (put blank if you want to return 404)
secret_path = "/pwndrop"                    # secret URL path, which upon visiting will allow your browser to access the login page of the admin panel (make sure to change the default value)
EOF

