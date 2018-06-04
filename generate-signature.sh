#/bin/sh
pbpaste | tr -d "\n" | openssl sha1 -sign private_key.pem | openssl base64 | tr -- '+=/' '-_~'