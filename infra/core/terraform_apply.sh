#!/bin/bash
SLEEP_TIME=10

terraform apply -var "injected_key_status=Active"
echo "Terraform apply complete. Waiting for $SLEEP_TIME seconds for instance to finish initialising."
sleep $SLEEP_TIME

echo "Deactivating temporary access key."
terraform apply -var "injected_key_status=Inactive" 

