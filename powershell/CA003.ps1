$conditions = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessConditionSet
$conditions.Applications = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessApplicationCondition
$conditions.Applications.IncludeApplications = "All"
$conditions.Users = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessUserCondition
$conditions.Users.IncludeGroups = "6c96716b-b32b-40b8-9009-49748bb6fcd5"
$conditions.Users.ExcludeGroups = "f753047e-de31-4c74-a6fb-c38589047723"
$conditions.SignInRiskLevels = @('high', 'medium')
$controls = New-Object -TypeName Microsoft.Open.MSGraph.Model.ConditionalAccessGrantControls
$controls._Operator = "OR"
$controls.BuiltInControls = "mfa"

New-AzureADMSConditionalAccessPolicy -DisplayName "CA003: Require MFA for medium + sign-in risk" -State "enabledForReportingButNotEnforced" -Conditions $conditions -GrantControls $controls
