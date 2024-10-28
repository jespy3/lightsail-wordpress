#!/bin/bash

echo "Hello World! Executing the user-data script to install Docker and Docker Compose."

# Removing potential conflicting packages with the Docker installation
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do \
  apt-get remove $pkg; \
done

# Add Docker's official GPG key
apt-get update
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker Repo to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# At this point, you can list available versions with:
#apt-cache madison docker-ce | awk '{ print $3 }'

# Then choose the version you want, hard coding it here:
VERSION_STRING=5:27.3.1-1~debian.12~bookworm

# Install Docker with
apt-get install -y \
  docker-ce=$VERSION_STRING \
  docker-ce-cli=$VERSION_STRING \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

# Installing docker compose
apt-get install -y docker-compose-plugin

echo "Completed installing Docker and docker compose."

# Steps to set up AWS credentials
mkdir -p /home/admin/.aws

cat <<EOF > /home/admin/.aws/credentials
[default]
aws_access_key_id = ${aws_access_key_id}
aws_secret_access_key = ${aws_secret_access_key}
EOF

# Ensure only owner can read and write
chmod 600 /home/admin/.aws/credentials

# Ensuring the credentials file is used before awscli commands
export AWS_SHARED_CREDENTIALS_FILE=/home/admin/.aws/credentials

# Retrieve values from Parameter Store and set them as environment variables
export MYSQL_ROOT_PASSWORD=$(aws ssm get-parameter --name "/lightsail-wordpress/compose_environment/MYSQL_ROOT_PASSWORD" --with-decryption --query "Parameter.Value" --output text)
export MYSQL_DATABASE=$(aws ssm get-parameter --name "/lightsail-wordpress/compose_environment/MYSQL_DATABASE" --with-decryption --query "Parameter.Value" --output text)
export MYSQL_PASSWORD=$(aws ssm get-parameter --name "/lightsail-wordpress/compose_environment/MYSQL_PASSWORD" --with-decryption --query "Parameter.Value" --output text)
export MYSQL_USER=$(aws ssm get-parameter --name "/lightsail-wordpress/compose_environment/MYSQL_USER" --with-decryption --query "Parameter.Value" --output text)
export WORDPRESS_DB_NAME=$(aws ssm get-parameter --name "/lightsail-wordpress/compose_environment/WORDPRESS_DB_NAME" --with-decryption --query "Parameter.Value" --output text)
export WORDPRESS_DB_PASSWORD=$(aws ssm get-parameter --name "/lightsail-wordpress/compose_environment/WORDPRESS_DB_PASSWORD" --with-decryption --query "Parameter.Value" --output text)
export WORDPRESS_DB_USER=$(aws ssm get-parameter --name "/lightsail-wordpress/compose_environment/WORDPRESS_DB_USER" --with-decryption --query "Parameter.Value" --output text)

# Create the compose.yaml file, where the keyword is replaced by terraform file
cat <<EOL > /home/admin/compose.yaml
${docker_compose_content}
EOL

if [ -f /home/admin/compose.yaml ]; then
    echo "compose.yaml created successfully."
else
    echo "Failed to create compose.yaml."
fi

# Unset exported variables for safety
unset MYSQL_ROOT_PASSWORD
unset MYSQL_DATABASE
unset MYSQL_PASSWORD
unset MYSQL_USER
unset WORDPRESS_DB_NAME
unset WORDPRESS_DB_PASSWORD
unset WORDPRESS_DB_USER

# Create the mount point if it doesn't exist
mkdir -p /mnt/wordpress-db

# Add fstab entry if it doesn't already exist
if ! grep -q "/mnt/wordpress-db" /etc/fstab; then
  echo "/dev/xvdf /mnt/wordpress-db ext4 defaults,nofail 0 2" >> /etc/fstab
fi

# Mount all filesystems
mount -a

# Change ownership of the mounted volume to the MySQL user in the container "999"
chown -R 999:999 /mnt/wordpress-db

# Verify the mount was successful
if mountpoint -q /mnt/wordpress-db; then
    echo "Disk mounted successfully."

    # Start up the wordpress and mysql containers
    docker compose -f /home/admin/compose.yaml up -d
    sleep 5
else
    echo "Failed to mount disk. Not starting Docker containers."
fi

PUBLICIP=$(curl -s ipinfo.io/ip)

docker exec -i wordpress_db mysql -u root -pjibpass -e "\
  USE wordpress; \
	UPDATE wp_options SET option_value = \"http://$PUBLICIP\" WHERE option_name = 'siteurl'; \
	UPDATE wp_options SET option_value = \"http://$PUBLICIP\" WHERE option_name = 'home';"


# Security hardening steps
WP_DIR="/var/www/html"

# Set directory permissions to 755 (rwxr-xr-x)
docker exec -i wordpress_app find $WP_DIR -type d -exec chmod 755 {} \;

# Set file permissions to 644 (rw-r--r--)
docker exec -i wordpress_app find $WP_DIR -type f -exec chmod 644 {} \;

# Secure wp-config.php
docker exec -i wordpress_app chmod 600 $WP_DIR/wp-config.php

# Installing certbot and docker plugin for nginx
apt-get install -y certbot
apt-get install -y python3-certbot-nginx

