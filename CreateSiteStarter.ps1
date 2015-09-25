#Usage: PowerShell -ExecutionPolicy Bypass -File .\CreateSiteStarter.ps1 %1
param(
    [string]$projectName = "AzurePublishWebsite"
) #Must be the first statement in your script
 
# Security Configuration - So the Power Shell Script can connect to Your Azure Subscription
# Follow instructions to download this file for your Azure Subscription
Import-AzurePublishSettingsFile –PublishSettingsFile "YOUR_AZURE_PUBLISH_SETTINGS_FILE.publishsettings" 
 
Select-AzureSubscription -Default –SubscriptionName "[Subscription Name]"
 
# Per project params'
$projectName = "azamoghconsultants-" + $projectName
Write-Host "Arg: $projectName"
$hostName = $projectName + ".azurewebsites.net"
 
# Environment constants
$location = "West US"
$webResourceGroup = "Default-Web-WestUS"
$webHostingPlan = "DefaultServerFarm"
$dbResourceGroup = "Default-SQL-WestUS"
$dbServerName = "DB_SERVER_NAME"
$dbServerLogin = "DB_SERVER_LOGIN"
$dbServerPassword = "DB_PASSWORD"
$apiVersion = "2014-04-01"
 
# Build Machine Environment Constants
# Location of the Project on your machine
$projectLocation = "C:\Projects\AzurePublishWebsite"
# Location of the Build File (in this case msbuild file)
$buildFileLocation = $projectLocation + "\build"
# Location of the Package that needs to be published to the Azure Cloud
$pkgPath = $buildFileLocation + "\AzurePkg.zip"
# Location of the db Scripts that need to be executed on the DB
$dbScriptsLocation = $projectLocation + "\build\Published\dbscripts"
 
# Computed vars
$dbName = $projectName + "Db"
$dbLoginName = $dbName + "Login"
$dbPassword = [guid]::NewGuid()
$dbUserName = $dbName + "User"
 
# Make sure we kick off in service management mode
Switch-AzureMode AzureServiceManagement
 
# Create the site in the appropriate location
New-AzureWebSite $projectName -Location $location
 
# Turn off PHP
Set-AzureWebsite -Name $projectName -PhpVersion Off
 
# Create a SQL DB
New-AzureSqlDatabase -ServerName $dbServerName -DatabaseName $dbName -Edition "Basic" -MaxSizeGB 2
 
# Switch over to the resource manager
Switch-AzureMode AzureResourceManager
 
# Fire up SMO
Add-Type -Path 'C:\Program Files (x86)\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll'
 
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Server=tcp:" + $dbServerName + ".database.windows.net;Database=master;User ID=" + $dbServerLogin + ";Password=" + $dbServerPassword + ";"
$srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $conn
$db = $srv.Databases["master"]
 
"DB Created: " + $db
"Databases :" +$db.Databases
 
# Create the login
$login = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Login -ArgumentList $srv, $dbLoginName
$login.LoginType = "SqlLogin"
$login.PasswordPolicyEnforced = $false
$login.PasswordExpirationEnabled = $false
$login.Create($dbPassword)
 
# Add the user to the DB
$db = $srv.Databases[$dbName]
$dbUser = New-Object -TypeName Microsoft.SqlServer.Management.Smo.User -ArgumentList $db, $dbUserName
$dbUser.Login = $dbLoginName
$dbUser.Create()
 
# Summary
"DB user is: " + $dbLoginName
"DB password is: " + $dbPassword
 
# Prepare the Database - By Executing the SQL Files from the SQL Scripts Location
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Server=tcp:" + $dbServerName + ".database.windows.net;Database="+ $dbName +";User ID=" + $dbServerLogin + ";Password=" + $dbServerPassword + ";"
$query = [IO.File]::ReadAllText($dbScriptsLocation+"\dbscript1.sql")
$command = New-Object -TypeName System.Data.SqlClient.SqlCommand($query, $conn)
$conn.Open()
$command.ExecuteNonQuery()
$conn.Close()
 
#Build the Application - Based upon the BuildStrategy Used for the Application
cd $buildFileLocation
# Build Command Takes the following parameters:
# ClientName - Client Name Customization
# ClientDBUserName - Build Connection String
# ClientDBPassword - Build Connection String
msbuild buildWebApplication.xml /t:CIPublish /p:ClientName=$projectName /p:ClientDBUserName=$dbLoginName /p:ClientDBPassword=$dbPassword
 
# Switch over to the resource manager
Switch-AzureMode AzureServiceManagement

#Publishes the Package Build in the Previous Step (Zip File) to Azure Website Project 
Publish-AzureWebsiteProject -Name $projectName -Package $pkgPath
