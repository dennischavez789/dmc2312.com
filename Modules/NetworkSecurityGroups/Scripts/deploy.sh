#!/bin/bash
modulePath=~/repos/shaw/acf/Modules
location='eastus2'
subscription='sz-shared-p-01'

moduleName='NSGs'
templateFile="$modulePath/$moduleName/deploy.json"
parametersFile="$modulePath/$moduleName/Parameters/parameters.json"

#logging='--debug'
logging='--verbose'
rg='sz-security-p-nsg-01'

az group exists -g "$rg" --subscription $subscription || {
    az group create -g "$rg" -l "$location" --subscription $subscription
}
az deployment group create -g $rg --subscription $subscription -f "$templateFile" -p "$parametersFile" $logging
