$modulePath = '~/repos/shaw/acf/Modules/'

$moduleName = 'NSGs'
$subscription = 'sz-shared-p-01'
$resourceGroupName = 'sz-security-p-nsg-01'

$templateFile = "$modulePath/$moduleName/deploy.json"
$parametersFile = "$modulePath/$moduleName/Parameters/parameters.json"
$location = "East US 2"

Set-AzContext -Subscription $subscription

if (-not (Get-AzResourceGroup -Name "$resourceGroupName" -ErrorAction SilentlyContinue)) {
    $Location = "$location" -replace " ",""
    New-AzResourceGroup -Name "$resourceGroupName" -Location "$Location"
}

$DeploymentInputs = @{
#    nsgNameBase = "$nsg";
    ResourceGroupName     = "$resourceGroupName";
    TemplateFile          = "$templateFile";
    TemplateParameterFile = "$parametersFile";
    Mode                  = "Incremental";
    Verbose               = $true;
    ErrorAction           = "Stop"
}

New-AzResourceGroupDeployment @DeploymentInputs