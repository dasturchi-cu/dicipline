& "$PSScriptRoot\sync-ai-env.ps1"
Set-Location "$PSScriptRoot\.."
flutter build apk --debug
Write-Host "APK: build\app\outputs\flutter-apk\app-debug.apk"
