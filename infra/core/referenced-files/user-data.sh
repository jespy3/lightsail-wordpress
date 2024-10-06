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

# Create the compose.yaml file, where the keyword is replaced by terraform file
cat <<EOL > /home/admin/compose.yaml
DOCKER_COMPOSE_CONTENTS
EOL
