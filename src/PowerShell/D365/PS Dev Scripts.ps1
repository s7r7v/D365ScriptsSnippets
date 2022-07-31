##[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
##Install d365fo.tools and DBA tools PowerShell modules
Install-Module -Name @('dbatools','d365fo.tools')
Update-Module -Name @('dbatools','d365fo.tools')

## Stop D365FO instance
Stop-D365Environment
## DB Sync 
Invoke-D365DBSync -Verbosity Detailed
## Start AOS
Start-D365Environment