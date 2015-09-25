param(
    [string]$projectName = "AzurePublishWebsite"
) #Must be the first statement in your script
 
# Security Configuration
# Used to connect to the Subscription
Import-AzurePublishSettingsFile –PublishSettingsFile "YOUR_CREDENTIALS_FILE.publishsettings" 
 
Select-AzureSubscription -Default –SubscriptionName "SUBSCRIPTION_NAME"
 
$projectName = "azamoghconsultants-" + $projectName
Write-Host "Arg: $projectName"
 
# Constants
$dbServerName = "DB_SERVER_NAME"
$dbServerLogin = "DB_SERVER_LOGIN"
$dbServerPassword = "DB_SERVER_PASSWORD"
$apiVersion = "2014-04-01"
 
# Computed vars
$dbName = $projectName + "Db"
$dbLoginName = $dbName + "Login"
$dbPassword = [guid]::NewGuid()
$dbUserName = $dbName + "User"
 
# Make sure we kick off in service management mode
Switch-AzureMode AzureServiceManagement
 
# Delete the website
Remove-AzureWebsite $projectName -Force
 
# Drop the database
Remove-AzureSqlDatabase -ServerName $dbServerName -DatabaseName $dbName -Force
