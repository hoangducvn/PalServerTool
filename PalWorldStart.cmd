@echo off
IF EXIST pwsh.exe (
	set GAMENAME=pwsh
) ELSE (
	set GAMENAME=powershell
)
start %GAMENAME% -noprofile -executionpolicy bypass -file ".\ToolFunc\PalWorldFunc.ps1"