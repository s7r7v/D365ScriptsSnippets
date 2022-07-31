#region Parameters
$folder = 'C:\Temp\upd'
$archiveFileName = 'ServiceUpdate_10025.zip'
$runbookId = 'SRV-Runbook25'
$ErrorActionPreference = 'Stop'
#endregion
 
#region Derived values
$file = Join-Path $folder $archiveFileName
$runbookFile = Join-Path $folder "$runbookId.xml"
$extracted = Join-Path $folder ([System.IO.Path]::GetFileNameWithoutExtension($archiveFileName))
$topologyFile = Join-Path $extracted 'DefaultTopologyData.xml'
$updateInstaller = Join-Path $extracted 'AXUpdateInstaller.exe'
#endregion
 
 #region FUNCTIONS
Function ExtractFiles
{
    Unblock-File $file
    Expand-Archive -LiteralPath $file -Destination $extracted
}
 
Function SetTopologyData
{
    [xml]$xml = Get-Content $topologyFile
    $machine = $xml.TopologyData.MachineList.Machine
 
    # Set computer name. 
    #Use {$env:computername} function for Azure hosted environments
    #$machine.Name = $env:computername
    $machine.Name = "localhost"
 
    #Set service models
    $serviceModelList = $machine.ServiceModelList
    $serviceModelList.RemoveAll()
 
    $instalInfoDll = Join-Path $extracted 'Microsoft.Dynamics.AX.AXInstallationInfo.dll'
    [void][System.Reflection.Assembly]::LoadFile($instalInfoDll)
 
    $models = [Microsoft.Dynamics.AX.AXInstallationInfo.AXInstallationInfo]::GetInstalledServiceModel()
    foreach ($name in $models.Name)
    {
        $element = $xml.CreateElement('string')
        $element.InnerText = $name
        $serviceModelList.AppendChild($element)
    }
 
    $xml.Save($topologyFile)
}
 
Function GenerateRunbook
{
    $serviceModelFile = Join-Path $extracted 'DefaultServiceModelData.xml'
    & $updateInstaller generate "-runbookId=$runbookId" "-topologyFile=$topologyFile" "-serviceModelFile=$serviceModelFile" "-runbookFile=$runbookFile"
}
 
Function ImportRunbook
{
    & $updateInstaller import "-runbookfile=$runbookFile"
}
 
Function ExecuteRunbook
{
    & $updateInstaller execute "-runbookId=$runbookId"
}
 
Function RerunRunbook([int] $step)
{
    & $updateInstaller execute "-runbookId=$runbookId" "-rerunstep=$step"
}
 
Function SetStepComplete([int] $step)
{
    & $updateInstaller execute "-runbookId=$runbookId" "-setstepcomplete=$step"
}
 
Function ExportRunbook
{
    & $updateInstaller export "-runbookId=$runbookId" "-runbookfile=$runbookFile"
}
#endregion

#region STEPS - FULL

ExtractFiles
SetTopologyData
GenerateRunbook
ImportRunbook
ExecuteRunbook
#RerunRunbook(25)

#endregion