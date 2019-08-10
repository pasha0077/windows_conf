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
. $PSScriptRoot\selfsigningremove.ps1
# SIG # Begin signature block
# MIIFfQYJKoZIhvcNAQcCoIIFbjCCBWoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUI4l8ZQY+lTVperLc4QLdGKIj
# odqgggMbMIIDFzCCAf+gAwIBAgIQaFld5nlk15pHqlA0bqjyazANBgkqhkiG9w0B
# AQsFADAXMRUwEwYDVQQDDAxNeXNlbGZQYXNoYTMwHhcNMTkwODEwMjAwNTE2WhcN
# MjAwODEwMjAyNTE2WjAXMRUwEwYDVQQDDAxNeXNlbGZQYXNoYTMwggEiMA0GCSqG
# SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDDVxmkbVDLK4bDtwbE6YvcamrgQJiwcRao
# 3+ONb4/haKsU59skEnqu4ejL3oa4F1eiHqHAWAc7zveZ23ueMmGOpvM4RSWeLLHx
# Ju6T5zN7shGaZuMgSyQz5D2UnMlaphGf2H2MqR2n/UE29arAubzgNLZ6GIN6pkg5
# lNQGT/ZO9X4sBvfFS4hB8oH34gdBvdmSiVvZ1Xg4k0txLoxSCuXJh7lpJNsOcMG1
# M6+Wxv9KyVTRZZgpUO8EUWSS4TePNFehDqnBwV2gu60chCkWzQ6N02vJe2PiEG3u
# ra7lSkf4br/ZqYBT1TKHcdYpYvFQZM9E44xOuUPYRwY1SaATQJYRAgMBAAGjXzBd
# MA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAXBgNVHREEEDAO
# ggxNeXNlbGZQYXNoYTMwHQYDVR0OBBYEFOKLxhVTwAWoTKsjE81Kllnk+pz3MA0G
# CSqGSIb3DQEBCwUAA4IBAQBASQhmZjxf7GnEV/m6tFbVnsyFFu3pJPGoIeTj05k7
# CmHel276mdlVPjQA77jhw1w11/HobtsGZshqov0RjeYmGDh7tHsrxEEbrvP0C9wp
# OOwnTdAxFt7nvwOyX7hjhbODbu5uvajZ6FuCeBPPWVY9r42hurOOr6GpOFncuAc+
# 0Hk7rQxME+wn8ZCoDV22+/5C9qe+CxnTRIQtBDZfbHM0ZdXfxi19PAxwKxPJZEsZ
# ouTFVctk1GKosIPHO7CBmAvIbfqOYrHDv4BEvQpzcXmGf7LoPs2/bBOD2kfvRoqh
# eUanAiAme9MtJmCDYiVhTEY2FlaGyHazWReAI8Qu89T8MYIBzDCCAcgCAQEwKzAX
# MRUwEwYDVQQDDAxNeXNlbGZQYXNoYTMCEGhZXeZ5ZNeaR6pQNG6o8mswCQYFKw4D
# AhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwG
# CisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZI
# hvcNAQkEMRYEFEplTkQbWkoclMQ/X8JuY8/TaFRlMA0GCSqGSIb3DQEBAQUABIIB
# AFZsRKOm5j5d4E6sOti7yKmy67/Ge/1mZUcbZ3CdUXiUi7GdvxGFe6NSAVpEfJFf
# 7nk1nwHJD8enrgX3sO7me2le+AJ5J8sPH8VhEYTILWBFO6NMHqTG1HC+zeBuRPYN
# 6QC2tlTKM5Jvtn+IhIOHmwiM/XOZAILjUbfAAchD6wOHXddFPKyNc3f9z5qZkfj8
# FE9venCMujo0r9817CoHP6tvZCjT6PlomIkZJYgKeRzXSARG05ZCEiEBjWyn7XRu
# 4JyIxQ/Xr4xJowNI2WvDCckAO4HqyRiBJyvCr2uUeurZ43mOz6tN3aeOsMLC7YIH
# GESYOMNHqoyA539Gr59sKa8=
# SIG # End signature block
