#!/bin/bash

# Load the local .env file
export $(grep -v '^#' .env | xargs)

terraform apply

# Unset each env variable to prevent acciental exposure
while read -r line || [ -n "$line" ]; do
  if [[ ! $line =~ ^# && $line =~ ^[^=]+ ]]; then
    var_name=$(echo "$line" | cut -d= -f1)
    unset "$var_name"
    echo "Successfully unset $var_name"
  fi
done < .env

echo "Terraform apply complete, environment variables unset."
