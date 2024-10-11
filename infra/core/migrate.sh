#!/bin/bash

# Load my local .env file
export $(grep -v '^#' .env | xargs)

# Get public IP via AWS CLI
PUBLICIP=$(aws lightsail get-instances | jq -r '.instances[0].publicIpAddress')

# Set path to key pair
KEYPATH=$(echo "$HOME/.ssh/keys/$KP_NAME.pem")

echo "Running mysqldump in the $LOCAL_CONTAINER_DB_NAME container..."
docker exec -i $LOCAL_CONTAINER_DB_NAME mysqldump -u $LOCAL_DB_USER -p$LOCAL_DB_PASS $LOCAL_DB_NAME > $DUMPFILE

echo "Copying $DUMPFILE into Lightsail instance..."
scp -i $KEYPATH $DUMPFILE admin@$PUBLICIP:/home/admin/$DUMPFILE

echo "Copying $DUMPFILE from Lightsail instance into Lightsail MySQL container..."
ssh -i $KEYPATH admin@$PUBLICIP sudo docker cp $DUMPFILE $LS_CONTAINER_DB_NAME:/$DUMPFILE

echo "Importing $DUMPFILE from Lightsail MySQL container into the DB..."
ssh -i $KEYPATH admin@$PUBLICIP sudo docker exec -i $LS_CONTAINER_DB_NAME mysql -u $LS_DB_USER -p$LS_DB_PASS $LS_DB_NAME < $DUMPFILE

echo "Updating the URLs from local to the PUBLICIP based URLs..."
ssh -i $KEYPATH admin@$PUBLICIP "sudo docker exec -i $LS_CONTAINER_DB_NAME mysql -u $LS_DB_USER -p$LS_DB_PASS -e '\
  USE $LS_DB_NAME; \
	UPDATE wp_options SET option_value = \"http://$PUBLICIP:8080\" WHERE option_name = \"siteurl\"; \
	UPDATE wp_options SET option_value = \"http://$PUBLICIP:8080\" WHERE option_name = \"home\";'"

