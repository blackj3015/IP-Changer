@echo off
set scriptDir=%~dp0
powershell.exe -NoExit -ExecutionPolicy Bypass -File "%scriptDir%IPChanger.ps1"
