$pfx = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 
$pass = ConvertTo-SecureString -String "password" -Force -AsPlainText
$certPat = "c:\SelfCert.pfx"
$pfx.import($certPat,$pass,"Exportable,PersistKeySet") 
#$pfx.import($cert.RawData,$pass,"Exportable,PersistKeySet") 

$store = new-object System.Security.Cryptography.X509Certificates.X509Store(
    [System.Security.Cryptography.X509Certificates.StoreName]::Root,
    "localmachine"
)
$store.open("MaxAllowed") 
$store.remove($pfx) 
$store.close()
$store = new-object System.Security.Cryptography.X509Certificates.X509Store(
    [System.Security.Cryptography.X509Certificates.StoreName]::TrustedPublisher,
    "localmachine"
)
$store.open("MaxAllowed") 
$store.remove($pfx) 
$store.close()
$store = new-object System.Security.Cryptography.X509Certificates.X509Store(
    [System.Security.Cryptography.X509Certificates.StoreName]::My,
    "currentuser"
)
$store.open("MaxAllowed") 
$store.remove($pfx) 
$store.close()
$store = new-object System.Security.Cryptography.X509Certificates.X509Store(
    [System.Security.Cryptography.X509Certificates.StoreName]::CertificateAuthority,
    "currentuser"
)
$store.open("MaxAllowed") 
$store.remove($pfx) 
$store.close()

del $certPat