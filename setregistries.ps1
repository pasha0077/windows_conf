#Below cmdlet is to make the ps1 run
#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Function SetRegistry {
    Param($enable,$setting,$path,$keyname,$keytype,$keyvalue)
    If (($enable.ToUpper() -eq "YES") -OR ($enable.ToUpper() -eq "TRUE")) {
        Write-Host "Setting :"$setting
        If (!(Test-Path $path)) {
		    New-Item -Path $path -Force | Out-Null
	    }
	    Set-ItemProperty -Path $path -Name $keyname -Type $keytype -Value $keyvalue
	}
    Else
    {
        Write-Host "Skipping :"$setting
    }
}

[xml]$xml=get-content $PSScriptRoot\registries.xml
$nodes = select-xml "//registry" $xml
$nodes|foreach-object{
    SetRegistry -setting $_.node.name -enable $_.node.enable -path $_.node.path -keyname $_.node.keyname -keytype $_.node.keytype -keyvalue $_.node.keyvalue
}