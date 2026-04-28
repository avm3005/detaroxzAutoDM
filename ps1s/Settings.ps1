# Requires -RunAsAdministrator
$e = [char]27
$smPath = [Environment]::GetFolderPath("ApplicationData") + "\Microsoft\Windows\Start Menu\Programs\AutoDM"

function Get-ValidTime ($Prompt) {
    while ($true) {
        $timeStr = Read-Host "$e[3m$Prompt$e[0m"
        try { return [datetime]::Parse($timeStr).ToString("h:mm tt") } 
        catch { Write-Host "  -> Invalid format. Use HH:MM AM/PM.`n" -ForegroundColor Red }
    }
}

while ($true) {
    Clear-Host
    Write-Host "$e[1;38;5;51m========================================$e[0m"
    Write-Host "$e[1;38;5;213m            AutoDM Dashboard            $e[0m"
    Write-Host "$e[1;38;5;51m========================================$e[0m`n"
    
    $tLight = Get-ScheduledTask -TaskName "AutoDM - Light Mode" -ErrorAction SilentlyContinue
    $tDark = Get-ScheduledTask -TaskName "AutoDM - Dark Mode" -ErrorAction SilentlyContinue
    $tSync = Get-ScheduledTask -TaskName "AutoDM - LogOn Sync" -ErrorAction SilentlyContinue

    $lTime = if ($tLight) { [datetime]::Parse($tLight.Triggers[0].StartBoundary).ToString("h:mm tt") } else { "N/A" }
    $dTime = if ($tDark) { [datetime]::Parse($tDark.Triggers[0].StartBoundary).ToString("h:mm tt") } else { "N/A" }

    $autoStatus = if ($tLight.State -ne 'Disabled') { "$e[1;38;5;46mEnabled$e[0m" } else { "$e[1;38;5;196mDisabled$e[0m" }
    $syncStatus = if ($tSync.State -ne 'Disabled') { "$e[1;38;5;46mEnabled$e[0m" } else { "$e[1;38;5;196mDisabled$e[0m" }
    
    $isSmHidden = $false
    if (Test-Path $smPath) { $isSmHidden = ((Get-Item $smPath -Force).Attributes -band [System.IO.FileAttributes]::Hidden) -eq [System.IO.FileAttributes]::Hidden }
    $smStatus = if ($isSmHidden) { "$e[1;38;5;196mHidden$e[0m" } else { "$e[1;38;5;46mVisible$e[0m" }

    Write-Host "$e[1m1.$e[0m Change Light Mode Time   (Current: $e[33m$lTime$e[0m)"
    Write-Host "$e[1m2.$e[0m Change Dark Mode Time    (Current: $e[33m$dTime$e[0m)"
    Write-Host "$e[1m3.$e[0m Toggle Log-on Trigger    (Current: $syncStatus)"
    Write-Host "$e[1m4.$e[0m Toggle Auto Switching    (Current: $autoStatus)"
    Write-Host "$e[1m5.$e[0m Toggle Start Menu Vis.   (Current: $smStatus)"
    Write-Host "$e[1m6.$e[0m Exit Dashboard`n"

    $choice = Read-Host "$e[1;36mSelect an option (1-6)$e[0m"

    switch ($choice) {
        '1' {
            $newLight = Get-ValidTime "Enter NEW LIGHT mode time"
            $trigger = New-ScheduledTaskTrigger -Daily -At $newLight
            Set-ScheduledTask -TaskName "AutoDM - Light Mode" -Trigger $trigger | Out-Null
            Write-Host "Updated!" -ForegroundColor Green; Start-Sleep -Seconds 1
        }
        '2' {
            $newDark = Get-ValidTime "Enter NEW DARK mode time"
            $trigger = New-ScheduledTaskTrigger -Daily -At $newDark
            Set-ScheduledTask -TaskName "AutoDM - Dark Mode" -Trigger $trigger | Out-Null
            Write-Host "Updated!" -ForegroundColor Green; Start-Sleep -Seconds 1
        }
        '3' {
            if ($tSync.State -ne 'Disabled') { Disable-ScheduledTask -TaskName "AutoDM - LogOn Sync" | Out-Null } 
            else { Enable-ScheduledTask -TaskName "AutoDM - LogOn Sync" | Out-Null }
            Write-Host "Toggled Log-on Sync." -ForegroundColor Yellow; Start-Sleep -Seconds 1
        }
        '4' {
            if ($tLight.State -ne 'Disabled') {
                Disable-ScheduledTask -TaskName "AutoDM - Light Mode" | Out-Null
                Disable-ScheduledTask -TaskName "AutoDM - Dark Mode" | Out-Null
            } else {
                Enable-ScheduledTask -TaskName "AutoDM - Light Mode" | Out-Null
                Enable-ScheduledTask -TaskName "AutoDM - Dark Mode" | Out-Null
            }
            Write-Host "Toggled Auto Switching." -ForegroundColor Yellow; Start-Sleep -Seconds 1
        }
        '5' {
            if (Test-Path $smPath) {
                $item = Get-Item $smPath -Force
                if ($isSmHidden) {
                    $item.Attributes = $item.Attributes -band (-bnot [System.IO.FileAttributes]::Hidden)
                    Write-Host "Start Menu folder is now VISIBLE." -ForegroundColor Green
                } else {
                    $item.Attributes = $item.Attributes -bor [System.IO.FileAttributes]::Hidden
                    Write-Host "Start Menu folder is now HIDDEN." -ForegroundColor Yellow
                }
            }
            Start-Sleep -Seconds 1
        }
        '6' { exit }
        default { Write-Host "Invalid option." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
}
