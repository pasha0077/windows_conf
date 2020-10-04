$qa = New-Object -ComObject shell.application

$Exceptions = @("Desktop", "Downloads")
($qa.Namespace("shell:::{679F85CB-0220-4080-B29B-5540CC05AAB6}").Items() | Where-Object { $_.IsFolder -EQ $true -And $_.Name -notin $Exceptions}).InvokeVerb("unpinfromhome")

# To add 'C:\path\to\folder' to quick access:
#$qa.NameSpace('C:\path\to\folder').Self.InvokeVerb("pintohome")