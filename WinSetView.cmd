@Echo Off
Rem Run WinSetView.hta to create or update WinSetViewParams.txt
Set /p Params=<".\AppData\WinSetViewParams.txt"
Powershell.exe -ExecutionPolicy Bypass .\WinSetView.ps1 %Params%