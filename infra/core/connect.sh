#!/bin/bash

# Load my local .env file
export $(grep -v '^#' .env | xargs)

# Get public IP via AWS CLI
PUBLICIP=$(aws lightsail get-instances | jq -r '.instances[0].publicIpAddress')

# Set path to key pair
KEYPATH=$(echo "$HOME/.ssh/keys/$KP_NAME.pem")

echo "Connecting to instance..."
# Connect to instance via SSH
ssh -i $KEYPATH admin@$PUBLICIP

