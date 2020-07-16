# @TODO

wget https://raw.githubusercontent.com/Raikia/FiercePhish/master/install.sh  -O /tmp/fiercephish-install.sh -q

cat <<EOF > ~/fiercephish.config
CONFIGURED=true
VERBOSE=true
APACHE_PORT=80
WEBSITE_DOMAIN="127.0.0.1"
EMAIL_DOMAIN="localhost"
MYSQL_ROOT_PASSWD="mysqlPasswd"
ADMIN_USERNAME="admin"
ADMIN_EMAIL="root@localhost"
ADMIN_PASSWORD="defaultpass"
CREATE_SWAPSPACE=false  
EOF

echo 'table filter chain INPUT proto tcp dport (25) ACCEPT;' > /etc/ferm/ferm.d/smtp.conf
systemctl reload ferm

# End
touch /tmp/fiercephish.sh.done