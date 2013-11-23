#!/bin/bash

#
# RAX-specific configuration
#
export CLOUD_CONTAINER="YourContainerName" 
export CLOUDFILES_USERNAME="YourRackspaceUsername"
export CLOUDFILES_APIKEY="YourRackspaceCloudAPIKey"
# Datacenter (ORD, DFW, IAD, etc.)
export CLOUDFILES_REGION="ORD"


#
# GPG-specific configuration
#
export PASSPHRASE="Your signing key GPG passphrase"
export SIGN_PASSPHRASE="Your encryption key GPG passphrase"
# Key IDs, not your passphrases
export SIGNING_KEY_ID="ID of your signing key from Part 3 Step 3"
export ENCRYPTION_KEY_ID="ID of your encryption key from Part 3 Step 3"

#
# Duplicity-specific configuration
#
# Do a full backup if it's been more than ___ days (15D = 15 days)
export TIME_BETWEEN_FULLS="15D"
# Remove old backups if older than ___ days (31D = 31 days)
export REMOVE_OLDER_THAN="31D"

export DUPLICITY_OPTIONS="--full-if-older-than $TIME_BETWEEN_FULLS --volsize 250 --exclude-other-filesystems \
                          --sign-key $SIGNING_KEY_ID --encrypt-key $ENCRYPTION_KEY_ID"

echo "Setting ulimit at 4096 files..."
ulimit -n 4096
echo "Running Duplicity backup..."
echo $DUPLICITY_OPTIONS
duplicity $DUPLICITY_OPTIONS ~/dev cfpyrax+http://${CLOUD_CONTAINER}

echo "Removing old backups..."
duplicity remove-older-than $REMOVE_OLDER_THAN --force cfpyrax+http://${CLOUD_CONTAINER}

unset PASSPHRASE
unset SIGN_PASSPHRASE
unset CLOUDFILES_APIKEY
