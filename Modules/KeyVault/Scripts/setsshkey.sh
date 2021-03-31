#!/bin/bash
modulePath=/home/milosh/repos/CBO\ -\ MVC\ Build/Modules/KeyVault
subscription='m-shared1-01'

vault='m-boc-1akv-hubiam-01'
key='adminSshKey'
valueFile="$modulePath/Scripts/id_rsa"

# Generate SSH public/private key pair if nonexistent
if [ ! -f "$valueFile" ]; then
  ssh-keygen -f "$valueFile" -P ''
fi

# Store the public SSH key in the vault for linux configuration
az keyvault secret set --vault-name $vault -n $key --subscription $subscription -f "$valueFile.pub" -e ascii
# Store the private SSH key in the vault for reference
az keyvault secret set --vault-name $vault -n "$key-private" --subscription $subscription -f "$valueFile" -e ascii
