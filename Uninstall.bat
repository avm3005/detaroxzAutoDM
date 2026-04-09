@echo off
:: Launch Uninstall as Admin
powershell.exe -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -NoProfile -File "%~dp0ps1s\Uninstall-AutoDM.ps1"' -Verb RunAs"
