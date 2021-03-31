param(
  [Parameter(Mandatory = $true)]
  [string]$spnCreationFile
)

Write-output "Using file path $SPNCreationFile"
#region test File Path
if (Test-Path $spnCreationFile) {
  $spnFile = (Get-Content $spnCreationFile -Raw | ConvertFrom-Json)
  $spnsToCreate = $spnFile.spns
  $keyVaultName = $spnFile.keyVault
  $resourceGroupName = $spnFile.resourceGroup
  $subscriptionName = $spnFile.subscriptionName
}
else {
  Write-Output "path does not exist. Exiting..."
  exit
}
#endregion

#region Parse name to determine subscription & set context
Write-Output "Using Subscription $subscriptionName"

Set-AzContext -Subscription $subscriptionName
#endregion

#check to see if KV exists
$kvExists = Get-AzKeyVault | Where { $_.VaultName -eq $keyVaultName } -ErrorAction SilentlyContinue
if (!$kvExists) {
  Write-Error "no Key Vault found with name $keyVaultName in Resource Group $resourceGroupName" -ErrorAction Stop
}

#create certificates for SPNs
foreach ($spn in $spnsToCreate) {
  Write-Output "`nWorking on SPN:($($spn.Name))"
  #region generate key vault Certificate
  #check if certificate already exists with that SPN name
  Write-Output "Working on Certificate for SPN:($($spn.Name))"
  $certExists = Get-AzKeyVaultCertificate -VaultName $keyVaultName | Where { $_.Name -eq $spn.name }
  if (!$certExists) {
    $Policy = New-AzKeyVaultCertificatePolicy -SecretContentType "application/x-pkcs12" -SubjectName "CN=$($spn.name)" -IssuerName "Self" -ValidityInMonths 12
    Add-AzKeyVaultCertificate -VaultName $keyVaultName -Name $spn.name -CertificatePolicy $Policy
    $loopBreak = 0
    Do {
      Write-Output "checking status of certificate creation"
      $status = Get-AzKeyVaultCertificateOperation -VaultName $keyVaultName -Name $spn.name
      if ($status.Status -ne "Completed") {
        Write-Output "certificate not created. sleeping for 20 seconds"
        sleep 20
      }
    }
    while (($loopBreak -le 20) -and ($status.Status -ne "Completed"))
    if ($status.Status -ne "completed") {
      Write-Error "Certificate did not complete creation in time. Exiting..." -ErrorAction Stop
    }
  }
  else {
    Write-Output "certificate for Service Principal: $($spn.name) already exists"
  }
  $cert = Get-AzKeyVaultCertificate -VaultName $keyVaultName -Name $spn.name
  #endregion

  #region Create SPN in Azure AD with Cert
  Write-Output "Working on creating SPN:($($spn.Name))"
  $certValue = [System.Convert]::ToBase64String($cert.Certificate.RawData)
  $sp = Get-AzADServicePrincipal | Where { $_.DisplayName -eq $spn.name }
  if (!$sp) {
    Write-Output "Creating Service Principal: $($spn.name)"
    $sp = New-AzADServicePrincipal -DisplayName $spn.name -CertValue $certValue -EndDate $cert.Certificate.NotAfter -StartDate $cert.Certificate.NotBefore
    $loopBreak = 0
    Do {
      Write-Output "Checking status of service Principal creation"
      $sp = Get-AzADServicePrincipal -DisplayName $spn.name
      if (!$sp) {
        Write-Output "Service Principal not provisioned. sleeping for 20 seconds"
        sleep 60
      }
    }
    while (($loopBreak -le 20) -and (!$sp))
    Write-Output "Service Principal: $($spn.name) created"
  }
  else {
    Write-Output "Service Principal with name $($spn.name) Already exists. Skipping"
  }
  #endregion

  #region check if secret is required & has been created
  if ($spn.createCredential) {
    Write-Output "Working on Secret for SPN:($($spn.Name))"
    $secretExists = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name "$($spn.Name)-secret"
    if (!$secretExists) {
      #create the Secret
      $credential = New-AzADSpCredential -ObjectId $sp.Id
      #store the secret in KV
      Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "$($spn.Name)-secret" -SecretValue $credential.Secret -Expires $cred.EndDate
    }
    else {
      Write-Output "Secret for SPN:($($spn.Name)) already exists. Skipping"
    }
  }
  #endregion
}
