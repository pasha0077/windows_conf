$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -DnsName Myself -Type CodeSigningCert
$pass = ConvertTo-SecureString -String "password" -Force -AsPlainText
$CertPath = "Cert:\CurrentUser\My\$($cert.Thumbprint)"
$CurrFolder = read-host "Folder Path to files";
Export-PfxCertificate  -Cert $CertPath -FilePath c:\SelfCert.pfx -Password $pass

$pfx = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 
$certPat = "c:\SelfCert.pfx"
$pfx.import($certPat,$pass,"Exportable,PersistKeySet") 
#$pfx.import($cert.RawData,$pass,"Exportable,PersistKeySet") 

$store = new-object System.Security.Cryptography.X509Certificates.X509Store(
    [System.Security.Cryptography.X509Certificates.StoreName]::Root,
    "localmachine"
)
$store.open("MaxAllowed") 
$store.add($pfx) 
$store.close()
$store2 = new-object System.Security.Cryptography.X509Certificates.X509Store(
    [System.Security.Cryptography.X509Certificates.StoreName]::TrustedPublisher,
    "localmachine"
)
$store2.open("MaxAllowed") 
$store2.add($pfx) 
$store2.close()
#$cert = Get-ChildItem -Path 'Cert:\CurrentUser\My\A9FA1AFB76E549529F1444179E7139CDCAB55F1B';
$cert.EnhancedKeyUsageList;
Set-AuthenticodeSignature -Certificate:$cert -FilePath:$CurrFolder'\setregistries.ps1';
Set-AuthenticodeSignature -Certificate:$cert -FilePath:$CurrFolder'\permissions.ps1';
Set-AuthenticodeSignature -Certificate:$cert -FilePath:$CurrFolder'\selfsigningremove.ps1';