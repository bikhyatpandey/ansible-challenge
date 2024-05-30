#!/bin/bash

# Variables
HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname || echo "localhost")
SSL_DIR="/etc/httpd/ssl"
SSL_CERT="$SSL_DIR/selfsigned.crt"
SSL_KEY="$SSL_DIR/selfsigned.key"
APACHE_CONF="/etc/httpd/conf.d/ssl.conf"

# Create SSL directory
mkdir -p $SSL_DIR

# Generate private key without passphrase
openssl genpkey -algorithm RSA -out $SSL_KEY

# Generate CSR (Certificate Signing Request)
openssl req -new -key $SSL_KEY -out $SSL_DIR/selfsigned.csr -subj "/CN=$HOSTNAME"

# Generate self-signed certificate
openssl x509 -req -days 365 -in $SSL_DIR/selfsigned.csr -signkey $SSL_KEY -out $SSL_CERT

# Ensure mod_ssl is loaded
cat <<EOL > /etc/httpd/conf.modules.d/00-ssl.conf
LoadModule ssl_module modules/mod_ssl.so
EOL

# Create Apache SSL configuration
cat <<EOL > $APACHE_CONF
<VirtualHost *:80>
    ServerName $HOSTNAME
    Redirect permanent / https://$HOSTNAME/
</VirtualHost>

<VirtualHost *:443>
    ServerName $HOSTNAME

    SSLEngine on
    SSLCertificateFile $SSL_CERT
    SSLCertificateKeyFile $SSL_KEY

    <Directory "/var/www/html">
        AllowOverride All
        Require all granted
    </Directory>

    # Add headers to enforce security
    Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
    Header always set X-Frame-Options DENY
    Header always set X-Content-Type-Options nosniff

    ErrorLog logs/ssl_error_log
    TransferLog logs/ssl_access_log
    LogLevel warn
</VirtualHost>
EOL
systemctl enable httpd
systemctl start httpd

apachectl configtest

systemctl reload httpd

