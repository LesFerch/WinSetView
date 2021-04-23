@Echo Off

if not exist ".\AppData\WinSetViewParams.txt" echo Usage:- ^
Run WinSetView.hta to create or update WinSetViewParams.txt & pause & exit

Set /p Params=<".\AppData\WinSetViewParams.txt"
Powershell.exe -ExecutionPolicy Bypass .\WinSetView.ps1 %Params%
