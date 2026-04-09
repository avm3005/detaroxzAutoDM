# Requires -RunAsAdministrator
Clear-Host
Write-Host "Removing AutoDM..." -ForegroundColor Red
$tasks = @("AutoDM - Light Mode", "AutoDM - Dark Mode", "AutoDM - LogOn Sync")
foreach ($task in $tasks) { if (Get-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue) { Unregister-ScheduledTask -TaskName $task -Confirm:$false } }
$startMenu = [Environment]::GetFolderPath("ApplicationData") + "\Microsoft\Windows\Start Menu\Programs\AutoDM"
if (Test-Path $startMenu) { Remove-Item -Path $startMenu -Recurse -Force -ErrorAction SilentlyContinue }
Write-Host "Queuing directory deletion..."
$cmdArgs = "/c timeout /t 2 >nul & rmdir /s /q `"C:\Scripts\detaroxzAutoDM`""
Start-Process -FilePath "cmd.exe" -ArgumentList $cmdArgs -WindowStyle Hidden
exit
