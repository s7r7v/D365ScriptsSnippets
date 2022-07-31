# amend path so it points to your tf.exe file
Set-Alias -Name "tf" -Value "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\TF.exe"

# Veriables
$TeamProjectCollectionUrl = "https://ctsd365space.visualstudio.com/CTSD365space"

# List workspaces
tf workspaces /owner:roman.shatokhin@ciellos.com /format:detailed /collection:$TeamProjectCollectionUrl

# Delete workspace from particular collection by name
#tf workspace /delete "D365CHANGETRACK;anthraxsrv@hotmail.com" /collection:$TeamProjectCollectionUrl

