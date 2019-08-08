#Below cmdlet is needed to make the ps1 run
#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
. $PSScriptRoot\permissions.ps1

Function ModifyRegistry {
    Param($enable,$action,$setting,$path,$keyname,$keytype,$keyvalue)
    If (($enable.ToUpper() -eq "YES") -OR ($enable.ToUpper() -eq "TRUE")) {
        Write-Host "Setting :"$setting
        #$path,$keyname,$keytype,$keyvalue
        
        If($action.ToUpper() -eq "DELETEPATH")
        {
            If ((Test-Path $path)) {
                Remove-Item -Path $path -Recurse 
	        }
        }
        ElseIf($action.ToUpper() -eq "DELETEKEY") {
            If ((Test-Path $path)) {
                Remove-ItemProperty -Path $path -Name $keyname 
	        }
        }
        ElseIf($action.ToUpper() -eq "HKCR") {
            New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
            EnableCLSRootKeyWrite -key $path
            If (!(Test-Path "HKCR:\$($path)")) {
		        New-Item -Path "HKCR:\$path" -Force | Out-Null
	        }
	        Set-ItemProperty -Path "HKCR:\$path" -Name $keyname -Type $keytype -Value $keyvalue
            DisableCLSRootKeyWrite -key $path
        }
        Else
        {
            If (!(Test-Path $path)) {
		        New-Item -Path '$path' -Force | Out-Null
	        }
	        Set-ItemProperty -Path $path -Name $keyname -Type $keytype -Value $keyvalue
        }
	}
    Else
    {
        Write-Host "Skipping setting: "$setting
    }
}

[xml]$xml=get-content $PSScriptRoot\registries.xml
$nodes = select-xml "//registry" $xml
$nodes|foreach-object{
    ModifyRegistry -setting $_.node.name -action $_.node.action -enable $_.node.enable -path $_.node.path -keyname $_.node.keyname -keytype $_.node.keytype -keyvalue $_.node.keyvalue
} 