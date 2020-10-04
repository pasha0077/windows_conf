1. First open powershell as administrator, copy the contents of selfsigningwithcerts.ps1 to a temp file, run it, it asks for folder path, give the folder where the repo is cloned.
2. If successful, it creates certificates, installs as root and trusted provider and digitally sign the remaining all files. 
3. Uncomment first line in setregistries.ps1
4. Now open setregistries.ps1 from the same powershell window, run it, it delivers all the configurations and then removes the certificates from the pc. Keep the two files (ps1 and xml) in same folder while running
5. The settings are to be done manually, copy all the settings folder to c:\
5.1 For npp, Settings->Preferences->Cloud set the location to C:\settings\npp
5.2 For winmerge, import the settings from settings->winmerge->winmerge_config.ini file
5.3 For git, append the contents in settings->git->gitconfig to C:\Program Files\Git\etc\gitconfig 