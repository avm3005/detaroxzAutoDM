@echo off
:: Launch Settings as Admin
powershell.exe -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -NoProfile -File "%~dp0ps1s\Settings.ps1"' -Verb RunAs"
