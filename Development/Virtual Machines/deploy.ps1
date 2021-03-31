$rg = 'Development'
$deploymentName = 'dc'
$parameterFile = 'C:\Users\dechavez\OneDrive - Microsoft\Desktop\Work\Git\dmc2312.com\Development\Virtual Machines\Parameters\parameters.json'
New-AzResourceGroupDeployment `
    -Name $deploymentname `
    -ResourceGroupName $rg `
    -TemplateFile 'deploy.json' `
    -TemplateParameterFile $parameterFile