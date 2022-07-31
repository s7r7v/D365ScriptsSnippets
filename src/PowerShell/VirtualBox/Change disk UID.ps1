#### Sets execution policy to allow Windows 10 to execute the PS scripts. Run this command if neccecery
#### set-executionpolicy remotesigned
########## VARIABLES ##########
$VBoxManager = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
$VirtualDiskAbsolutePath = "D:\SIKICH-LEMANS\FinandOps10.0.17_lemans.vhd"
$VBArgs = @('internalcommands', 'sethduuid', $VirtualDiskAbsolutePath)
#### COMMAND to change a disk's UUID ####
& $VBoxManager $VBArgs