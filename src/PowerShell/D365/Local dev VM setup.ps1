# Resolve error in browser - ERR_HTTP2_INADEQUATE_TRANSPORT_SECURITY
function MakeRegistryChanges
{
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\HTTP\Parameters"
    $EnableHttp2TlsProp = "EnableHttp2Tls"
    $EnableHttp2CleartextProp = "EnableHttp2Cleartext"
    $PropValue = "0"

    if(!(Test-Path $registryPath))
    {
        Write-Host "Specified Registry path $registryPath does not exist. MakeRegistryChanges function did not resolve ERR_HTTP2_INADEQUATE_TRANSPORT_SECURITY error. Please check it in manual way." -ForegroundColor Red
    }
    else
    {
        New-ItemProperty -Path $registryPath -Name $EnableHttp2TlsProp -Value $PropValue -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path $registryPath -Name $EnableHttp2CleartextProp -Value $PropValue -PropertyType DWORD -Force | Out-Null
    }
}
#Disable IE Enhanced Security Configuration
function Disable-IEESC
{
$AdminKey = “HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}”
$UserKey = “HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}”
Set-ItemProperty -Path $AdminKey -Name “IsInstalled” -Value 0
Set-ItemProperty -Path $UserKey -Name “IsInstalled” -Value 0
Stop-Process -Name Explorer
Write-Host “IE Enhanced Security Configuration (ESC) has been disabled.” -ForegroundColor Green
}
Disable-IEESC
#Disable UAC
Write-Verbose( "Disable UAC") -Verbose 
# More details here https://www.powershellgallery.com/packages/cEPRSDisableUAC
& "$env:SystemRoot\System32\reg.exe" ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 4 /f
& "$env:SystemRoot\System32\reg.exe" ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableInstallerDetection /t REG_DWORD /d 1 /f
& "$env:SystemRoot\System32\reg.exe" ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f 
gpupdate
#password age pop up
net accounts /maxpwage:unlimited
# update regitry keys
Write-Verbose( "Update Registry keys") -Verbose 
MakeRegistryChanges
#Rename and restart
$NewComputerName = 'SRV-SBX'
$NewComputerNamelength = $NewComputerName.Length
if($NewComputerNamelength -ge 15)
{
Write-Host "Computer name should be less than 15 symbols. Current length is $NewComputerNamelength symbols. Please update computer name. And repeat last step" -ForegroundColor Red
}
else
{
Rename-Computer -NewName $NewComputerName
Restart-Computer
}