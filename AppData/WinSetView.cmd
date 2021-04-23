@Echo Off

if exist ".\WinSetViewParams.txt" goto OK
echo:
echo Usage:- Run WinSetView.hta to create or update WinSetViewParams.txt
echo         Or drop a previously saved/renamed WinSetViewParams.txt on this cmd
echo:
pause & exit
:OK
Set /p Params=<".\WinSetViewParams.txt"
if exist ".\%~n1.txt" Set /p Params=<".\%~n1.txt"

Powershell.exe -ExecutionPolicy Bypass ..\WinSetView.ps1 %Params%