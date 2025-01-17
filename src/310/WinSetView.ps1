# WinSetView (Globally Set Explorer Folder Views)
# Les Ferch, lesferch@gmail.com, 2021 - 2025
# WinSetView.ps1 (Powershell script to set selected views)

# One command line paramater is supported
# Provide INI file name to set Explorer views
# Provide REG file name to restore Explorer views from backup

Param (
  $File = ''
)

Set-StrictMode -Off

#$ExecutionContext.SessionState.LanguageMode = "ConstrainedLanguage"

$Constrained = $false
If ($ExecutionContext.SessionState.LanguageMode -eq "ConstrainedLanguage") {$Constrained = $true}

If (-Not $Constrained) {$host.ui.RawUI.WindowTitle = "WinSetView"}

# Read entire INI file into a dictionary object

Function Get-IniContent ($FilePath) {
  $ini = @{}
  Switch -regex -file $FilePath {
    '^\[(.+)\]' # Section
    {
      $section = $matches[1]
      $ini[$section] = @{}
    }
    '(.+?)\s*=(.*)' # Key
    {
      $name,$value = $matches[1..2]
      $ini[$section][$name] = $value
    }
  }
  Return $ini
}

# Determine Windows version (also works for Windows Server)
# Treat Windows 11 same as Windows 10 because they have same folder types and properties

$Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion'
$Value = 'CurrentVersion'
$NTVer = (Get-ItemProperty -Path $Key -Name $Value).$Value
$Value = 'CurrentBuild'
$CurBld = [Int](Get-ItemProperty -Path $Key -Name $Value).$Value
$Value = 'UBR'
$UBR = [Int](Get-ItemProperty -Path $Key -Name $Value  -ErrorAction SilentlyContinue).$Value
If ($NTVer -eq '6.1') {$WinVer = '7'}
If (($NTVer -eq '6.2') -Or ($NTVer -eq '6.3')) {$WinVer = '8'}
$Value = 'CurrentMajorVersionNumber'
Try {[Int]$MajVer = (Get-ItemProperty -ErrorAction Stop -Path $Key -Name $Value).$Value}
Catch {$MajVer = 0}
If ($MajVer -ge 10) {$WinVer = '10'}

If (($WinVer -ne '7') -And ($WinVer -ne '8') -And ($WinVer -ne '10')){
  Write-Host `n'Windows 7, 8, 10 or higher is required.'`n
  Read-Host -Prompt 'Press Enter to continue'
  Exit
}

# Windows 7 includes Powershell 2 so this check should never fail

If ($PSVersionTable.PSVersion.Major -lt 2) {
  Write-Host `n'Powershell 2 or higher is required.'`n
  Read-Host -Prompt 'Press Enter to continue'
  Exit
}

# Verify INI or REG file is supplied on the command line

$FileExt = ''
If ($File.Length -gt 4) {$FileExt = $File.SubString($File.Length-4)}

If (-Not(($FileExt -eq '.ini') -Or ($FileExt -eq '.reg'))) {
  Write-Host `n'No INI or REG file supplied on command line.'`n
  Read-Host -Prompt 'Press Enter to continue'
  Exit
}

# Create PSScriptRoot variable if not exist (i.e. PowerShell 2)

If (!$PSScriptRoot) {$PSScriptRoot = Split-Path $Script:MyInvocation.MyCommand.Path -Parent}

# Make sure we can access the INI (or REG) file

set-location $PSScriptRoot

If (-Not(Test-Path -Path $File)) {
  Write-Host `n"File not found: $File"`n
  Read-Host -Prompt 'Press Enter to continue'
  Exit
}

If ($Constrained) {
  Write-Host `n"Settings on this computer put PowerShell in Constrained Language Mode."
  Write-Host "Some steps may take a bit longer to work around this restriction."
}

#Keys for use with Reg.exe (or CSReg.exe) command line
$BagM = 'HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU'
$Bags = 'HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags'
$Shel = 'HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell'
$Bag1 = 'HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\1\Shell\{5C4F28B5-F869-4E84-8E60-F11DB97C5CC7}'
$Bag2 = 'HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\2\Shell\{5C4F28B5-F869-4E84-8E60-F11DB97C5CC7}'
$Strm = 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams'
$Defs = 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults'
$CUFT = 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes'
$LMFT = 'HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes'
$Advn = 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
$Clcm = 'HKCU\Software\Classes\CLSID\{86CA1AA0-34AA-4E8B-A509-50C905BAE2A2}'
$Srch = 'HKCU\Software\Microsoft\Windows\CurrentVersion\Search'
$Srhl = 'HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings'
$Srdc = 'HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB'
$BwgM = 'HKCU\Software\Microsoft\Windows\Shell\BagMRU'
$Bwgs = 'HKCU\Software\Microsoft\Windows\Shell\Bags'
$Desk = 'HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop'
$TBar = 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Desktop'
$Lets = 'HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement'
$Remd = 'HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
$E10A = 'HKCU\Software\Classes\CLSID\{2aa9162e-c906-4dd9-ad0b-3d24a8eef5a0}'
$E10B = 'HKCU\Software\Classes\CLSID\{6480100b-5a83-4d1e-9f69-8ae5a88e9a33}'
$ESTR = 'HKCU\Software\Classes\CLSID\{52205fd8-5dfb-447d-801a-d0b52f2e83e1}'
$ESTC = 'HKCU\Software\Classes\CLSID\{52205fd8-5dfb-447d-801a-d0b52f2e83e1}\shell\OpenNewWindow\command'
$CCMH = 'HKCU\Software\Classes\AllFileSystemObjects\shellex\ContextMenuHandlers\{C2FBB630-2971-11D1-A18C-00C04FD75D13}'
$MCMH = 'HKCU\Software\Classes\AllFileSystemObjects\shellex\ContextMenuHandlers\{C2FBB631-2971-11D1-A18C-00C04FD75D13}'
$UPol = 'HKCU\Software\Policies\Microsoft\Windows\Explorer'

#Keys for use with PowerShell
$ShPS = 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell'

#Keys for building REG files
$ImpR = '[HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\'

#File paths
$TempDir   = "$env:TEMP"
$AppData   = "$env:APPDATA\WinSetView"
$RegFile1  = "$TempDir\WinSetView1.reg"
$RegFile2  = "$TempDir\WinSetView2.reg"
$T1        = "$TempDir\WinSetView1.tmp"
$T2        = "$TempDir\WinSetView2.tmp"
$T3        = "$TempDir\WinSetView3.tmp"
$T4        = "$TempDir\WinSetView4.tmp"
$T5        = "$TempDir\WinSetView5.tmp"
$T6        = "$TempDir\WinSetView6.tmp"
$T7        = "$TempDir\WinSetView7.tmp"
$ShellBak  = "$TempDir\ShellBak.reg"
$DeskBak   = "$TempDir\DeskBak.reg"
$TBarBak   = "$TempDir\TBarBak.reg"
$TimeStr   = (get-date).ToString('yyyy-MM-dd-HHmm-ss')
$RegExe    = "$env:SystemRoot\System32\Reg.exe"
$CmdExe    = "$env:SystemRoot\System32\Cmd.exe"
$IcaclsExe = "$env:SystemRoot\System32\Icacls.exe"
$KillExe   = "$env:SystemRoot\System32\TaskKill.exe"
$UAppData  = "$env:UserProfile\AppData"
$CSRegExe  = "$PSScriptRoot\AppParts\CSReg.exe"
$ViveExe   = "$PSScriptRoot\AppParts\ViVeTool.exe"
$CloseExpW = "$PSScriptRoot\AppParts\CloseExplorerWindows.exe"

function Get-ShortPath($Path) {
  return (-join (& $CmdExe /c "for %p in ("""$Path""") do @echo:%~sp")).Trim()
}

$CSRegExe  = Get-ShortPath($CSRegExe)
$ViveExe   = Get-ShortPath($ViveExe)
$CloseExpW = Get-ShortPath($CloseExpW)

$C1=''; $C2=''; $C3=''; $C4=''; $C5=''

$regCheck = & $RegExe query HKU 2>$Null
if ($regCheck -eq $Null) {
  $RegExe = $CSRegExe
  If (-Not(Test-Path -Path $RegExe)) {
    Write-Host `n"File not found: $RegExe"`n
    Read-Host -Prompt 'Press Enter to continue'
    Exit
  }
}

& $CloseExpW

If ($PSVersionTable.PSVersion.Major -lt 5) {
  $userSID = (Get-WmiObject -Class Win32_UserAccount -Filter "Name='$env:UserName'").SID
}
Else {
  try { $userSID = (Get-CimInstance -ErrorAction Stop -ClassName Win32_UserAccount -Filter "Name='$env:UserName'").SID }
  catch {
    $key = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry64)
    $subKey =  $key.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI")
    $userSID = $subKey.GetValue("LastLoggedOnUserSID")
  }
}

$PolE = "HKU\$userSID\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$PolEM = "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$PolL = "HKU\$userSID\Software\Microsoft\Windows\CurrentVersion\Policies\ComDlg32\PlacesBar"

# Use script folder if we have write access. Otherwise use AppData folder.

$TestFile = "$PSScriptRoot\$TimeStr.txt"
Try {[io.file]::OpenWrite($TestFile).close()}
Catch {}
If (Test-Path -Path $TestFile) {
  Remove-Item $TestFile
  $AppData = "$PSScriptRoot\AppData"
}
$BakFile  = "$AppData\Backup\$TimeStr.reg"
$Custom   = "$AppData\WinSetViewCustom.reg"

Function AdjustPrefix($String) {
  $String = $String.Replace("System.Icaros.","Icaros.")
  $String = $String.Replace("System..","")
  Return $String
}

Function ResetThumbCache {
  $ThumbCacheFiles = "$Env:LocalAppData\Microsoft\Windows\Explorer\thumbcache_*.db"
  & $IcaclsExe $ThumbCacheFiles /grant Everyone:F >$Null 2>$Null
  Remove-Item -Force -ErrorAction SilentlyContinue $ThumbCacheFiles
}

Function ResetStoreAppViews {
  $Exclude = 'WindowsTerminal','WebViewHost','MSTeams','Win32Bridge.Server','PhoneExperienceHost','ClipChamp','ClipChamp.CLI'
  $Pkgs = "$env:LocalAppData\Packages"
  if (-Not(Test-Path -Path $Pkgs)) {return}
  If ($Constrained) {KillStoreAppsConstrained} Else {KillStoreApps}
  Get-ChildItem $Pkgs -Directory | ForEach-Object {
    Remove-Item -Force -ErrorAction SilentlyContinue "$Pkgs\$_\SystemAppData\Helium\UserClasses.dat"
  }
}

Function KillStoreApps {
  $Stor = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store'
  if (-Not(Test-Path -Path $Stor)) {return}
  $Key = Get-Item -Path $Stor
  ForEach ($ValueName in $($Key.GetValueNames())) {
    If ($ValueName -match 'c:\\program files\\windowsapps\\') {
      $FileName = Split-Path $ValueName -Leaf
      $FileNameBase = $FileName.ToLower().Replace(".exe","")
      If ($Exclude -NotContains $FileNameBase) {
        & $KillExe /im $FileName >$Null 2>$Null
      }
    }
  }
}

Function KillStoreAppsConstrained {
  $Stor = 'HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store'
  $registryValues = & $RegExe query $Stor
  $registryValues | ForEach-Object {
    $parts = $_.Trim() -split "  "
    $valueName = $parts[0]
    if ($valueName -match 'c:\\program files\\windowsapps\\') {
      $FileName = Split-Path $valueName -Leaf
      $FileNameBase = $FileName.ToLower().Replace(".exe","")
      if ($Exclude -NotContains $FileNameBase) {
        & $KillExe /im $FileName >$Null 2>$Null
      }
    }
  }
}

Function SetVirtualFolderColumns {
  If ($SetVirtualFolders -eq 1 -And $SetVirtualFolderColumns -eq 1) {
    Explorer 'C:\'
    Start-Sleep 1
    & $CloseExpW
    Start-Sleep 1
    Remove-Item $T1 2>$Null
    & $RegExe Export $Bag2 $T1 /y 2>$Null

    If (-Not(Test-Path -Path $T1)) { 
      & $RegExe Export $Bag1 $T1 /y
      $Data = Get-Content $T1 | Out-String
      $Data = $Data.Replace('\Bags\1\Shell\', '\Bags\AllFolders\Shell\')
    }
    Else {
      $Data = Get-Content $T1 | Out-String
      $Data = $Data.Replace('\Bags\2\Shell\', '\Bags\AllFolders\Shell\')
    }

    Out-File -InputObject $Data -encoding Unicode -filepath $T1
    & $RegExe Import $T1 /reg:64

    $Data = $Data.Replace('\Bags\AllFolders\Shell\', '\Bags\AllFolders\ComDlg\')
    Out-File -InputObject $Data -encoding Unicode -filepath $T1
    & $RegExe Import $T1 /reg:64

    $Data = $Data.Replace('\Bags\AllFolders\ComDlg\', '\Bags\AllFolders\ComDlgLegacy\')
    Out-File -InputObject $Data -encoding Unicode -filepath $T1
    & $RegExe Import $T1 /reg:64
  }  
}

Function RestartExplorer {
  & $RegExe Import $ShellBak 2>$Null
  & $RegExe Import $DeskBak 2>$Null
  & $RegExe Import $TBarBak 2>$Null
  & $RegExe Add $BwgM /v NodeSlots /d '02' /t REG_BINARY /f >$Null
  & $RegExe Add $BwgM /v NodeSlot /d 1 /t REG_DWORD /f >$Null
  If ($WinVer -ne '7') {ResetStoreAppViews}
  Stop-Process -Force -ErrorAction SilentlyContinue -ProcessName Explorer
  If ($ResetThumbs -eq 1) {ResetThumbCache}
  Explorer $PSScriptRoot
  Exit
}

Function DeleteUserKeys {
  & $RegExe Delete $BwgM /f 2>$Null
  & $RegExe Delete $Bwgs /f 2>$Null
  & $RegExe Delete $BagM /f 2>$Null
  & $RegExe Delete $Bags /f 2>$Null
  & $RegExe Delete $CUFT /f 2>$Null
  & $RegExe Delete $Defs /f 2>$Null
}

$Restore = ($FileExt -eq '.reg')

If ($Restore) {
  Write-Host `n'Restore from backup...'`n
}
Else {

  $iniContent = Get-IniContent $File
  $Reset = $iniContent['Options']['Reset']
  $Backup = $iniContent['Options']['Backup']
  $Generic = [Int]$iniContent['Options']['Generic']
  $NoFolderThumbs = [Int]$iniContent['Options']['NoFolderThumbs']
  $UnhideAppData = [Int]$iniContent['Options']['UnhideAppData']
  $UnhidePublicDesktop = [Int]$iniContent['Options']['UnhidePublicDesktop']
  $ClassicSearch = [Int]$iniContent['Options']['ClassicSearch']
  $HomeGrouping = [Int]$iniContent['Options']['HomeGrouping']
  $LibraryGrouping = [Int]$iniContent['Options']['LibraryGrouping']
  $SearchOnly = [Int]$iniContent['Options']['SearchOnly']
  $SetVirtualFolders = [Int]$iniContent['Options']['SetVirtualFolders']
  $SetVirtualFolderColumns = [Int]$iniContent['Options']['SetVirtualFolderColumns']
  $ThisPCoption = [Int]$iniContent['Options']['ThisPCoption']
  $ThisPCView = [Int]$iniContent['Options']['ThisPCView']
  $ThisPCNG = [Int]$iniContent['Options']['ThisPCNG']
  $ApplyViews = ($iniContent['Options']['ApplyViews'] -eq 1)
  $ApplyOptions = ($iniContent['Options']['ApplyOptions'] -eq 1)

  If ($Reset -eq 1) {
    Write-Host `n'Reset to Windows defaults...'`n
  }
  Else {
    Write-Host `n'Setting Explorer folder views...'`n
  }
}

Function RemoveTempFiles {
  Remove-Item $T1 2>$Null
  Remove-Item $T2 2>$Null
  Remove-Item $T3 2>$Null
  Remove-Item $T4 2>$Null
  Remove-Item $T5 2>$Null
  Remove-Item $T6 2>$Null
  Remove-Item $T7 2>$Null
}

$LogoExists = $false
Try { $LogoExists = (Get-ItemProperty -Path $ShPS -ErrorAction SilentlyContinue).logo -eq 'none' } Catch {}

RemoveTempFiles

If ($Backup -eq 1) {
  If (!(Test-Path -Path "$AppData\Backup")) {Mkdir "$AppData\Backup" >$Null}
  & $RegExe Export $BagM $T1 /y 2>$Null
  & $RegExe Export $Bags $T2 /y 2>$Null
  & $RegExe Export $Strm $T3 /y 2>$Null
  & $RegExe Export $CUFT $T4 /y 2>$Null
  & $RegExe Export $BwgM $T5 /y 2>$Null
  & $RegExe Export $Bwgs $T6 /y 2>$Null
  & $RegExe Export $Advn $T7 /y 2>$Null
  & $CmdExe /c Copy $T1+$T2+$T3+$T4+$T5+$T6+$T7 $BakFile >$Null 2>$Null
  RemoveTempFiles
}

If ($ApplyViews -Or $Restore) {

  # Backup current Desktop view details
  & $RegExe Export $Desk $DeskBak /y 2>$Null
  & $RegExe Export $TBar $TBarBak /y 2>$Null

  & $RegExe Delete $Desk /f 2>$Null
  Remove-Item $ShellBak 2>$Null
  Remove-Item -Path "$ShPS\*" -Recurse 2>$Null
  Remove-ItemProperty -Path "$ShPS" -Name  Logo 2>$Null
  Remove-ItemProperty -Path "$ShPS" -Name  FolderType 2>$Null
  Remove-ItemProperty -Path "$ShPS" -Name  SniffedFolderType 2>$Null
  & $RegExe Export $Shel $ShellBak /y 2>$Null

  # Clear current Explorer view registry values

  DeleteUserKeys

  # Restore from backup, restart Explorer, exit

  If ($Restore) {
    & $RegExe Import $File
    RestartExplorer
  }
}

If ($ApplyOptions) {

  # Enable/disable show of file extensions

  $ShowExt = [Int]$iniContent['Options']['ShowExt']
  & $RegExe Add $Advn /v HideFileExt /t REG_DWORD /d (1-$ShowExt) /f

  # Enable/disable compact view in Windows 11

  If ($CurBld -ge 21996) {
    $CompView = [Int]$iniContent['Options']['CompView']
    & $RegExe Add $Advn /v UseCompactMode /t REG_DWORD /d ($CompView) /f
  }

  # Enable/disable show hidden files and folders

  $ShowHidden = [Int]$iniContent['Options']['ShowHidden']
  & $RegExe Add $Advn /v Hidden /t REG_DWORD /d (2-$ShowHidden) /f

  # Enable/disable classic context menu in Windows 11

  If ($CurBld -ge 21996) {
    $ClassicContextMenu = [Int]$iniContent['Options']['ClassicContextMenu']
    If ($ClassicContextMenu -eq 1) {& $RegExe Add "$Clcm\InprocServer32" /reg:64 /f 2>$Null}
    Else {& $RegExe Delete $Clcm /reg:64 /f 2>$Null}
  }

  # Enable/disable Copy and Move items in context menu

  $CopyMoveInMenu = [Int]$iniContent['Options']['CopyMoveInMenu']
  If ($CopyMoveInMenu -eq 1) {
    & $RegExe Add $CCMH /reg:64 /f 2>$Null
    & $RegExe Add $MCMH /reg:64 /f 2>$Null
  }
  Else {
    & $RegExe Delete $CCMH /reg:64 /f 2>$Null
    & $RegExe Delete $MCMH /reg:64 /f 2>$Null
  }

  # Enable/disable Internet in Windows search

  $NoSearchInternet = [Int]$iniContent['Options']['NoSearchInternet']
  $NoSearchHighlights = [Int]$iniContent['Options']['NoSearchHighlights']
  If (($NoSearchInternet -eq 0) -or ($NoSearchHighlights -eq 0)) {
      & $RegExe Add $UPol /v DisableSearchBoxSuggestions /t REG_DWORD /d 0 /f 2>$Null
  }
  $NoSearchInternet = 1-$NoSearchInternet
  $NoSearchHighlights = 1-$NoSearchHighlights
  & $RegExe Add $Srch /v BingSearchEnabled /t REG_DWORD /d ($NoSearchInternet) /f
  & $RegExe Add $Srhl /v IsDynamicSearchBoxEnabled /t REG_DWORD /d ($NoSearchHighlights) /f
  & $RegExe Add $Srdc /v ShowDynamicContent /t REG_DWORD /d ($NoSearchHighlights) /f

  # Unhide/hide AppData folder

  If ($UnhideAppData -eq 1) {& $CmdExe /c attrib -h "$UAppData"}
  Else {& $CmdExe /c attrib +h "$UAppData"}

  # Enable/disable classic search
  # Only applicable if "new" search is enabled
  # If "new" search is disabled, then you get classic search

  If (($CurBld -ge 18363) -And ($CurBld -lt 21996)) {
    $Key = "HKCU\Software\Classes\CLSID\{1d64637d-31e9-4b06-9124-e83fb178ac6e}"
    If ($ClassicSearch -eq 1) {& $RegExe add "$Key\TreatAs" /ve /t REG_SZ /d "{64bc32b5-4eec-4de7-972d-bd8bd0324537}" /reg:64 /f 2>$Null}
    Else {& $RegExe delete $Key /reg:64 /f 2>$Null}
  }

  # Enable/disable numerical sort order (UAC)

  $NoNumericalSort = $iniContent['Options']['NoNumericalSort']

  $CurVal = & $RegExe Query $PolE /v NoStrCmpLogical 2>$Null
  If ($CurVal.Length -eq 4) {$CurVal = $CurVal[2][-1]} Else {$CurVal = 0}

  If ($CurVal -ne $NoNumericalSort) {
    $NoNumericalSort = [int]$NoNumericalSort
    $C1 = "$CSRegExe Add $PolE /v NoStrCmpLogical /t REG_DWORD /d $NoNumericalSort /f"
  }

  $CurVal = & $RegExe Query $PolEM /v NoStrCmpLogical 2>$Null
  If ($CurVal.Length -eq 4) {
    $CurVal = $CurVal[2][-1]
    If ($CurVal -ne $NoNumericalSort) {
      $NoNumericalSort = [int]$NoNumericalSort
      $C1 = "$C1;$CSRegExe Add $PolEM /v NoStrCmpLogical /t REG_DWORD /d $NoNumericalSort /f"
    }
  }

  # Enable/disable Windows 10 "new" search (UAC)

  If (($CurBld -ge 19045) -And ($CurBld -lt 21996) -And ($UBR -ge 3754)) {

    $Win10Search = $iniContent['Options']['Win10Search']

    $CurVal = & $ViveExe /query /id:18755234
    If ($CurVal[4] -Match 'Enabled') {$CurVal = '1'} Else {$CurVal = '0'}

    If ($CurVal -ne $Win10Search) {
      $Action = '/enable'
      If ($Win10Search -eq '0') {$Action = '/disable'}
      $C2 = "$ViveExe $Action /id:18755234"
    }
  }

  # Enable/disable Windows 11 App SDK Explorer (UAC)

  If (($CurBld -eq 22621) -And ($UBR -ge 3007) -And ($UBR -lt 3085)) {

    $Win11Explorer = $iniContent['Options']['Win11Explorer']

    $CurVal = & $ViveExe /query /id:40729001
    If ($CurVal[4] -Match 'Disabled') {$CurVal = '1'} Else {$CurVal = '0'}

    If ($CurVal -ne $Win11Explorer) {
      $Action = '/enable'
      If ($Win11Explorer -eq '1') {$Action = '/disable'}
      $C3 = "$ViveExe $Action /id:40729001"
    }
  }

  # Enable/disable Windows 10 Explorer on Windows 11

  If ($CurBld -ge 21996) {

    $Win10Explorer = $iniContent['Options']['Win10Explorer']

    If ($Win10Explorer -eq '1') {
      & $RegExe Add $E10A /ve /t REG_SZ /d "CLSID_ItemsViewAdapter" /reg:64 /f
      & $RegExe Add "$E10A\InProcServer32" /ve /t REG_SZ /d "C:\Windows\System32\Windows.UI.FileExplorer.dll_" /reg:64 /f
      & $RegExe Add "$E10A\InProcServer32" /v "ThreadingModel" /t REG_SZ /d "Apartment" /reg:64 /f
      & $RegExe Add $E10B /ve /t REG_SZ /d "File Explorer Xaml Island View Adapter" /reg:64 /f
      & $RegExe Add "$E10B\InProcServer32" /ve /t REG_SZ /d "C:\Windows\System32\Windows.UI.FileExplorer.dll_" /reg:64 /f
      & $RegExe Add "$E10B\InProcServer32" /v "ThreadingModel" /t REG_SZ /d "Apartment" /reg:64 /f

      # This binary value is required for the old Explorer to remember its window size and position
      & $RegExe Add "HKCU\Software\Microsoft\Internet Explorer\Toolbar\ShellBrowser" /f /v ITBar7Layout /t REG_BINARY /d 13000000000000000000000020000000100001000000000001000000010700005e01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
    }
    Else {
      & $RegExe Delete $E10A /reg:64 /f 2>$Null
      & $RegExe Delete $E10B /reg:64 /f 2>$Null
    }
  }
  
  # Remove/Restore Home in Navigation pane (Windows 11)
  
  $RemoveHome = [Int]$iniContent['Options']['RemoveHome']
  $Key = 'HKCU\Software\Classes\CLSID\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}'
  & $RegExe Add $Key /v System.IsPinnedToNameSpaceTree /d (1-$RemoveHome) /t REG_DWORD /reg:64 /f

  # Remove/Restore Gallery in Navigation pane (Windows 11)

  $RemoveGallery = [Int]$iniContent['Options']['RemoveGallery']
  $Key = 'HKCU\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}'
  & $RegExe Add $Key /v System.IsPinnedToNameSpaceTree /d (1-$RemoveGallery) /t REG_DWORD /reg:64 /f

  # Apply/remove Legacy Dialog Fix (UAC)

  If ($CurBld -ge 18363) {

    Try {
      $CurVal = & $RegExe Query $PolL /v Place1 2>$Null
      If ($CurVal.Length -eq 4) {$CurVal = '1'} Else {$CurVal = '0'}
    }
    Catch {
      $CurVal = '0'
    }

    $LegacyDialogFix = $iniContent['Options']['LegacyDialogFix']

    $DesktopPlace = 'shell:::{3936E9E4-D92C-4EEE-A85A-BC16D5EA0819}'
    If (($CurBld -ge 22621) -And ($UBR -ge 3007)) {
      $DesktopPlace = 'shell:::{F874310E-B6B7-47DC-BC84-B9E6B38F5903}'
    }

    If ($CurVal -ne $LegacyDialogFix) {
      If ($LegacyDialogFix -eq '1') {
        $A = "$CSRegExe Add $PolL /v Place0 /t REG_SZ /d '$DesktopPlace' /f"
        $B = "$CSRegExe Add $PolL /v Place1 /t REG_SZ /d 'shell:ThisPCDesktopFolder' /f"
        $C = "$CSRegExe Add $PolL /v Place2 /t REG_SZ /d 'shell:Libraries' /f"
        $D = "$CSRegExe Add $PolL /v Place3 /t REG_SZ /d 'shell:MyComputerFolder' /f"
        $E = "$CSRegExe Add $PolL /v Place4 /t REG_SZ /d 'shell:NetworkPlacesFolder' /f"
        $C4 = "$A;$B;$C;$D;$E"
      }
      Else {
        $C4 = "$CSRegExe Delete $PolL /f" 2>$Null
      }
    }
  }

  # Unhide/hide Public Desktop folder

  $folderPath = "C:\Users\Public\Desktop"
  $folder = Get-Item -Path $folderPath -Force
  if ($folder.Attributes -band [System.IO.FileAttributes]::Hidden) {
      If ($UnhidePublicDesktop -eq 1) {$C5 = "$CmdExe /c attrib -h $folderPath"}
  } else {
      If ($UnhidePublicDesktop -eq 0) {$C5 = "$CmdExe /c attrib +h $folderPath"}
  }

  # Execute commands that require UAC elevation

  $Cmd = "$C1$C2$C3$C4$C5"
  If ($Cmd -ne '') {
    $Cmd = "$C1;$C2;$C3;$C4;$C5"
    Try {
    Start-Process -WindowStyle Hidden -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command $Cmd" -Verb RunAs 2>$Null
    }
    Catch {
    }
  }

  # Enable/disable "Let's finish setting up", "Welcome experience", and "Tips and tricks"

  $NoSuggestions = [Int]$iniContent['Options']['NoSuggestions']
  $NoSuggestions = 1-$NoSuggestions
  & $RegExe Add $Lets /v ScoobeSystemSettingEnabled /t REG_DWORD /d ($NoSuggestions) /f
  & $RegExe Add $remd /v SubscribedContent-310093Enabled /t REG_DWORD /d ($NoSuggestions) /f
  & $RegExe Add $remd /v SubscribedContent-338389Enabled /t REG_DWORD /d ($NoSuggestions) /f

  # Set Explorer Start Folder

  & $RegExe Delete $ESTR /reg:64 /f 2>$Null
  $ExplorerStart = [Int]$iniContent['Options']['ExplorerStart']
  If ($ExplorerStart -eq 1) {
    $ExplorerStartOption = [Int]$iniContent['Options']['ExplorerStartOption']
    If ($ExplorerStartOption -eq 4) {
      $ExplorerStartPath = 'explorer ' + $iniContent['Options']['ExplorerStartPath']
      $ExplorerStartPath = $ExplorerStartPath -Replace '\\$', '\\'
      & $RegExe Add $ESTC /ve /t REG_SZ /d $ExplorerStartPath /reg:64 /f
      & $RegExe Add $ESTC /v DelegateExecute /t REG_SZ /reg:64 /f
    }
    Else {
      & $RegExe Add $Advn /v LaunchTo /t REG_DWORD /d ($ExplorerStartOption) /f
    }
  }
}

# If reset, restart Explorer and exit

If ($Reset -eq 1) {
  & $RegExe Delete $Strm /f 2>$Null
  RestartExplorer
}

# Function to help Set up views for This PC

Function SetBagValues ($Key) {
  & $RegExe Add $Key /v FFlags /d 0x41200001 /t REG_DWORD /f >$Null
  & $RegExe Add $Key /v LogicalViewMode /d $LVMode /t REG_DWORD /f >$Null
  & $RegExe Add $Key /v Mode /d $Mode /t REG_DWORD /f >$Null
  $Group = 1-$ThisPCNG
  & $RegExe Add $Key /v GroupView /d $Group /t REG_DWORD /f >$Null
  & $RegExe Add $Key /v IconSize /d $IconSize /t REG_DWORD /f >$Null
  & $RegExe Add $Key /v 'GroupByKey:FMTID' /d '{B725F130-47EF-101A-A5F1-02608C9EEBAC}' /t REG_SZ /f >$Null
  & $RegExe Add $Key /v 'GroupByKey:PID' /d 4 /t REG_DWORD /f >$Null
}

# Set view values based on selection index

Function SetViewValues($Index) {
  If ($Index -eq 1) {$Script:LVMode = 1; $Script:Mode = 4; $Script:IconSize = 16}
  If ($Index -eq 2) {$Script:LVMode = 4; $Script:Mode = 3; $Script:IconSize = 16}
  If ($Index -eq 3) {$Script:LVMode = 2; $Script:Mode = 6; $Script:IconSize = 48}
  If ($Index -eq 4) {$Script:LVMode = 5; $Script:Mode = 8; $Script:IconSize = 32}
  If ($Index -eq 5) {$Script:LVMode = 3; $Script:Mode = 1; $Script:IconSize = 16}
  If ($Index -eq 6) {$Script:LVMode = 3; $Script:Mode = 1; $Script:IconSize = 48}
  If ($Index -eq 7) {$Script:LVMode = 3; $Script:Mode = 1; $Script:IconSize = 96}
  If ($Index -eq 8) {$Script:LVMode = 3; $Script:Mode = 1; $Script:IconSize = 256}
}

Function BuildRegData($Key) {
  $Script:RegData += $Script:ImpR + "$Key\$GUID]`r`n"
  $Script:RegData += '@="' + $Script:FT + '"' + "`r`n"
  $Script:RegData += '"Mode"=dword:' + $Script:Mode + "`r`n"
  If ($Key -eq 'Shell') {
    $AutoArrange = [Int]$iniContent['Options']['AutoArrange'] * 1
    $AlignToGrid = [Int]$iniContent['Options']['AlignToGrid'] * 4
    $LastDigit = $AutoArrange + $AlignToGrid
    $Script:RegData += '"FFlags"=dword:4300000' + $LastDigit + "`r`n"
    Return
  }
  $Script:RegData += '"LogicalViewMode"=dword:' + $Script:LVMode + "`r`n"
  If ($Script:LVMode -eq 3) {$Script:RegData += '"IconSize"=dword:' + '{0:x}' -f $Script:IconSize + "`r`n"}
  $Group = 1-$FileDialogNG
  $Script:RegData += '"GroupView"=dword:' + $Group + "`r`n"
}

If ($ApplyViews) {

  # Enable/disable folder thumbnails

  If ($NoFolderThumbs -eq 1) {
    $ResetThumbs = !$LogoExists
    & $RegExe Add $Shel /v Logo /d none /t REG_SZ /f
  }
  Else {
    & $RegExe Delete $Shel /v Logo /f 2>$Null
    $ResetThumbs = $LogoExists
  }

  # Enable/Disable full row select (requires legacy spacing)

  $LegacySpacing = [Int]$iniContent['Options']['LegacySpacing']
  $NoFullRowSelect = 0
  If ($LegacySpacing -eq 1) {
    $NoFullRowSelect = [Int]$iniContent['Options']['NoFullRowSelect']
    & $RegExe Add $Advn /v FullRowSelect /t REG_DWORD /d (1-$NoFullRowSelect) /f
  }
  $SystemTextColor = $iniContent['Options']['SystemTextColor']
  & $RegExe Add 'HKCU\Control Panel\Colors' /v WindowText /t REG_SZ /d $SystemTextColor /f

  # The FolderTypes key does not include entries for This PC
  # This PC does not have a unique GUID so we'll set it's view via a Bags entry:

  If ($ThisPCoption -ne 0) {
    & $RegExe Add $BagM /v NodeSlots /d '02' /t REG_BINARY /f
    & $RegExe Add $BagM /v MRUListEx /d '00000000ffffffff' /t REG_BINARY /f >$Null
    & $RegExe Add $BagM /v '0' /d '14001F50E04FD020EA3A6910A2D808002B30309D0000' /t REG_BINARY /f >$Null
    & $RegExe Add "$BagM\0" /v NodeSlot /d 1 /t REG_DWORD /f >$Null
    $CustomIconSize = $iniContent['Generic']['IconSize']
    SetViewValues($ThisPCView)
    If ($CustomIconSize -ne '') {$IconSize = $CustomIconSize}
    $GUID = '{5C4F28B5-F869-4E84-8E60-F11DB97C5CC7}'
    SetBagValues("$Bags\1\ComDlg\$GUID")
    SetBagValues("$Bags\1\Shell\$GUID")
  }

  If ($Generic -eq 1) {& $RegExe Add $Shel /v FolderType /d Generic /t REG_SZ /f}

  If ($SetVirtualFolders -eq 1) {
    $GUID = $iniContent['Generic']['GUID']
    $GroupBy = $iniContent['Generic']['GroupBy']
    $CustomIconSize = $iniContent['Generic']['IconSize']
    SetViewValues([Int]$iniContent['Generic']['View'])
    If ($CustomIconSize -ne '') {$IconSize = $CustomIconSize}
    & $RegExe Add "$Bags\AllFolders\Shell\$GUID" /v FFlags /d '0x41200001' /t REG_DWORD /f
    & $RegExe Add "$Bags\AllFolders\Shell\$GUID" /v Mode /d "$Mode" /t REG_DWORD /f
    & $RegExe Add "$Bags\AllFolders\Shell\$GUID" /v LogicalViewMode /d "$LVMode" /t REG_DWORD /f
    If ($LVMode -eq 3) {& $RegExe Add "$Bags\AllFolders\Shell\$GUID" /v IconSize /d "$IconSize" /t REG_DWORD /f}
    If ($GroupBy -eq '') {& $RegExe Add "$Bags\AllFolders\Shell\$GUID" /v GroupView /d 0 /t REG_DWORD /f}
  }

  # Set Explorer folder view defaults:
  #  1) Export HKLM FolderTypes key
  #  2) Import FolderTypes key to HKCU
  #  2) Update HKCU FolderTypes default settings
  #  4) Restart Explorer
  # Note: Explorer will use HKCU key instead of HKLM key automatically

  # Copy FolderType key from HKLM to HKCU by exporting and importing

  & $RegExe Export $LMFT $RegFile1 /y
  $Data = Get-Content $RegFile1
  $Data = $Data -Replace 'HKEY_LOCAL_MACHINE','HKEY_CURRENT_USER'
  Out-File -InputObject $Data -encoding Unicode -filepath $RegFile1
  & $RegExe Import $RegFile1 /reg:64

  $FolderTypes = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes'

  # Create lookup table for path type properties so these can be excluded from
  # non-search views if the search-only option is enabled

  $PathItems = @{
    'ItemFolderPathDisplay' = ''
    'ItemFolderPathDisplayNarrow' = ''
    'ItemPathDisplay' = ''
    'ItemFolderNameDisplay' = ''
  }

  $RegData = ''

  Get-ChildItem $FolderTypes | Get-ItemProperty | ForEach {

    $FT = $_.CanonicalName
    If ($iniContent.ContainsKey($FT)) {
      $Include = [Int]$iniContent[$FT]['Include']
      
      If ($Include -eq 1) {

        $FileDialogOption = [Int]$iniContent[$FT]['FileDialogOption']
        $FileDialogView = [Int]$iniContent[$FT]['FileDialogView']
        $FileDialogNG = [Int]$iniContent[$FT]['FileDialogNG']

        $GUID = $iniContent[$FT]['GUID']
   
        $View = $iniContent[$FT]['View']
        If ($FileDialogOption -ne 1) {$FileDialogView = $View}

        If (($FileDialogOption -eq 1 -And $FT -ne 'Global') -Or ($SetVirtualFolders -eq 1 -And $GUID -eq '{5C4F28B5-F869-4E84-8E60-F11DB97C5CC7}')) {
          SetViewValues($FileDialogView)
          BuildRegData('ComDlg')
          BuildRegData('ComDlgLegacy')
        }

        SetViewValues($View)

        If ($LegacySpacing -eq 1) {
          BuildRegData('Shell')
        }

        $GroupBy = $iniContent[$FT]['GroupBy']
        $GroupByOrder = $iniContent[$FT]['GroupByOrder']
        If (($FT -eq 'HomeFolder') -And ($HomeGrouping -eq 0)) {
          $GroupBy = 'Home.Grouping'
          $GroupByOrder = '+'
        }
        If (($FT.IndexOf('Library') -gt 0) -And ($LibraryGrouping -eq 0)) {
          $GroupBy = 'ItemSearchLocation'
          $GroupByOrder = '+'
        }
        If ($GroupBy -ne '') {$GroupBy = "System.$GroupBy"}
        $GroupBy = AdjustPrefix($GroupBy)
        If ($GroupByOrder -eq '+') {$GroupByOrder = 1} Else {$GroupByOrder = 0}

        #Code added June 2023 to disable Sort 4
        $SortBy = $iniContent[$FT]['SortBy']
        If ($SortBy.Split(';').Count -eq 4) {
          $SortBy = $SortBy.SubString(0,$SortBy.LastIndexOf(';'))
        }
        $SortBy = 'prop:' + $SortBy
        $SortBy = $SortBy -Replace '\+','+System.'
        $SortBy = $SortBy -Replace '-','-System.'
        $SortBy = AdjustPrefix($SortBy)

        $CustomIconSize = $iniContent[$FT]['IconSize']
        If ($CustomIconSize -ne '') {$IconSize = $CustomIconSize}
        $INIColumnList = $iniContent[$FT]['ColumnList']
        $ArrColumnList = $INIColumnList.Split(';')
        $ColumnList = 'prop:'
        
        For($i=0; $i -lt $ArrColumnList.Count; $i++) {
          $ArrColumnListItem = $ArrColumnList[$i].Split(',')
          $Property = $ArrColumnListItem[2]
          If (($FT -Match 'Search') -Or (-Not ((($SearchOnly -eq 1) -And ($PathItems.ContainsKey($Property))) -Or ($Property -eq 'Search.Rank')))) {
            $Show = $ArrColumnListItem[0]
            $Width = ''; If ($ArrColumnListItem[1] -ne '') {$Width = '(' + $ArrColumnListItem[1] + ')'}
            $Property = 'System.' + $ArrColumnListItem[2]
            $Property = AdjustPrefix($Property)
            $ColumnList =  "$ColumnList$Show$Width$Property;"
          }
        }
        $ColumnList = $ColumnList.Trim(';')
        $Key = $_.PSPath
        $Key = "$Key\TopViews"
        If (Test-Path -Path $Key) {
          Get-ChildItem $Key | Get-ItemProperty | ForEach {
            $GUID = $_.PSChildName
            $ChildKey = $Key + '\' + $GUID
            Set-ItemProperty -Path $ChildKey -Name 'LogicalViewMode' -Value $LVMode
            Set-ItemProperty -Path $ChildKey -Name 'IconSize' -Value $IconSize
            Set-ItemProperty -Path $ChildKey -Name 'GroupBy' -Value $GroupBy
            Set-ItemProperty -Path $ChildKey -Name 'GroupAscending' -Value $GroupByOrder
            Set-ItemProperty -Path $ChildKey -Name 'SortByList' -Value $SortBy
            Set-ItemProperty -Path $ChildKey -Name 'ColumnList' -Value $ColumnList
          }
        }
      }
    }
  }

  # Export results for use with comparison tools such as WinMerge

  & $RegExe Export $CUFT $RegFile2 /y
  
  # Import Reg data to force dialog views
  # This is MUCH faster than creating the keys using PowerShell

  If ($RegData -ne '') {
    $RegData = "Windows Registry Editor Version 5.00`r`n`r`n" + $RegData
    Out-File -InputObject $RegData -filepath $T1
    & $RegExe Import $T1
  }
}

# Replicate General Item view to AllFolders reg key
SetVirtualFolderColumns

# Import Reg data for any custom settings

If (Test-Path -Path $Custom) {& $RegExe Import $Custom /reg:64}

RestartExplorer