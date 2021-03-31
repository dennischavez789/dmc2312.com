$rg = 'Development'
$deploymentName = 'dc'
$parameterFile = 'C:\Users\dechavez\OneDrive - Microsoft\Desktop\Programming\Microsoft\AIRS\VirtualMachines\Parameters\parameters.json'
New-AzResourceGroupDeployment `
    -Name $deploymentname `
    -ResourceGroupName $rg `
    -TemplateFile 'deploy.json' `
    -TemplateParameterFile $parameterFile