##Install d365fo.tools and DBA tools PowerShell modules
Install-Module -Name @('dbatools','d365fo.tools')
Update-Module -Name @('dbatools','d365fo.tools')
###########################################################
###############
###########################################################
Set-ExecutionPolicy Bypass -Scope Process -Force; 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
###########################################################
choco install postman -y