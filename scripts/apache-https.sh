
apt-get update
apt-get install -y apache2

# Install Default Apache Configuration
cat <<EOF > /etc/apache2/sites-available/default-ssl.conf
<IfModule mod_ssl.c>
<VirtualHost *:80>
    DocumentRoot /var/www/html
    <Directory "/var/www/html">
        AllowOverride All
    </Directory>
</VirtualHost>

<VirtualHost *:443>
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        AllowOverride All
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined

    SSLEngine on
    SSLProxyEngine on
    RewriteEngine On
    SSLProxyVerify none
    SSLProxyCheckPeerCN off
    SSLProxyCheckPeerName off
    SSLProxyCheckPeerExpire off
    ProxyPreserveHost On
    #ProxyPassMatch ^ https://127.0.0.1/$1
    #RedirectMatch ^ https://127.0.0.1/$1

    # certbot might update the certs
    SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
    SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

</VirtualHost>
</IfModule>
EOF

# Install htaccess to redirect 80 to 443, also a placeholder to spoof a website
cat <<EOF > /var/www/html/.htaccess
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R,L]
EOF

# Make some symlinks in the home directory
ln -s /var/www/html/.htaccess /root/htaccess
ln -s /etc/apache2/sites-available/default-ssl.conf default-ssl.conf

a2enmod ssl
a2enmod rewrite
a2enmod proxy_http
a2ensite default-ssl
systemctl restart apache2

# End
touch /tmp/apache-https.sh.done