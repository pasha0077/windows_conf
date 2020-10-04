$apps = @("Microsoft3DViewer", "WindowsAlarms", "WindowsFeedbackHub", "Getstarted", "XboxGamingOverlay", "MicrosoftSolitaireCollection",
            "SkypeApp", "WindowsCamera", "WindowsSoundRecorder", "YourPhone", "XboxApp", "ZuneVideo", "ZuneMusic", "MixedReality.Portal",
            "BingWeather", "XboxIdentityProvider", "Microsoft.People", "ParentControls", "OneNote", "XboxGameOverlay", "GetHelp", 
            "XboxSpeechToTextOverlay", "WindowsMaps")
foreach ($element in $apps) { 
    Get-AppxPackage *$element* | Remove-AppxPackage 
}