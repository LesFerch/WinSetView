REM CMD (batch file) script that will backup and restore user Explorer view settings.
REM This backup captures more than the backup built into WinSetView.
REM For a GUI-less restore, simply go to Cmd line and run Reg Import YourSettings.reg
REM where YourSettings.reg is the settings file captured with the backup option.

@Echo Off

Set MyName=Folder View Backup

Set Desktop=
Set Key="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
For /F "Skip=2 Tokens=2*" %%A In ('Reg Query %Key% /v Desktop 2^>Nul') Do Set Desktop=%%B

If Not Exist "%Desktop%" Set Desktop=%UserProfile%\Desktop

Set BakD="%Desktop%\%MyName%"
Set BakF="%Desktop%\%MyName%\%UserName%.reg"

Set TmpF="%Tmp%\Tmp.reg"

Set R01="HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU"
Set R02="HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags"
Set R03="HKCU\Software\Microsoft\Windows\Shell\BagMRU"
Set R04="HKCU\Software\Microsoft\Windows\Shell\Bags"
Set R05="HKCU\Software\Microsoft\Windows\ShellNoRoam\BagMRU"
Set R06="HKCU\Software\Microsoft\Windows\ShellNoRoam\Bags"
Set R07="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CIDOpen"
Set R08="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CIDSave"
Set R09="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32"
Set R10="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Modules\NavPane"
Set R11="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer"
Set R12="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults"
Set R13="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes"
Set R14="HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel"

Title %MyName%

:Menu
Set Mode=
Cls
Echo.
Echo 1. Create a backup of current Explorer folder views
Echo 2. Restore Explorer folder views from backup file
Echo 3. Clear current Explorer views and return to Windows defaults
Echo.
Set /P Mode=Choose option or press Enter to Exit: 

If "%Mode%"=="1" Goto BakChk
If "%Mode%"=="2" Goto ResChk
If "%Mode%"=="3" Goto ResChk
If "%Mode%"=="" Goto End
Echo.
Echo Invalid input.
Echo.
pause
Goto Menu

:BakChk
IF Not Exist %BakF% Goto Backup
Echo.
Echo You already have a backup folder and file on your desktop.
Echo Please move or rename the backup file and try again.
Echo.
pause
Goto Menu

:Backup
If Not Exist %BakD% Mkdir %BakD% 2>Nul
If Not Exist %BakD% Echo Unable to create backup folder. & Pause & Goto End
Echo.
Del %TmpF% 2>Nul & Reg Export %R01% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R02% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R03% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R04% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R05% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R06% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R07% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R08% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R09% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R10% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R11% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R12% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R13% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul & Reg Export %R14% %TmpF% /y 2>Nul & More %TmpF%>>%BakF% 2>Nul
Del %TmpF% 2>Nul
Echo.
Echo Backup complete.
Echo.
Pause
Goto Menu

:ResChk
If Exist %BakF% Goto Clear
Echo.
Echo You do not have a backup folder and file on your desktop.
Goto %Mode%A

:2A
Echo Place the backup folder and file on your desktop and try again.
Echo.
pause
Goto Menu

:3A
Echo Are you sure you want to clear settings without a backup?
Echo.
Set Choice=
Set /P Choice=Enter Y to continue or Enter to return to menu 
If /I "%Choice%"=="Y" Goto Clear
Goto Menu

:Clear
Echo.
Reg Delete %R01% /F 2>Nul
Reg Delete %R02% /F 2>Nul
Reg Delete %R03% /F 2>Nul
Reg Delete %R04% /F 2>Nul
Reg Delete %R05% /F 2>Nul
Reg Delete %R06% /F 2>Nul
Reg Delete %R07% /F 2>Nul
Reg Delete %R08% /F 2>Nul
Reg Delete %R09% /F 2>Nul
Reg Delete %R10% /F 2>Nul
Reg Delete %R11% /F 2>Nul
Reg Delete %R12% /F 2>Nul
Reg Delete %R13% /F 2>Nul
Reg Delete %R14% /F 2>Nul
Goto %Mode%B

:2B
Reg Import %BakF%
Echo.
Echo Restore complete.
Goto Done

:3B
Echo.
Echo Clear complete.

:Done
Echo.
Echo Press Enter to restart Explorer and apply settings.
Echo.
Pause

Taskkill /f /im explorer.exe
Start Explorer.exe

:End