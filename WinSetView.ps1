# WinSetView (Globally Set Explorer Folder Views)
# Les Ferch, lesferch@gmail.com, GitHub repository created 2021-03-26
# WinSetView.ps1 (Powershell script to set selected views)

# One command line paramater is supported
# Provide INI file name to set Explorer views
# Provide REG file name to restore Explorer views from backup

Param (
  $File = ''
)

#Set-PSDebug -Trace 1

$host.ui.RawUI.WindowTitle = "WinSetView"

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

#Keys for use with Reg.exe command line
$BagM = '"HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU"'
$Bags = '"HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags"'
$Shel = '"HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell"'
$Strm = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams"'
$Defs = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults"'
$CUFT = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes"'
$LMFT = '"HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes"'
$Advn = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"'
$Clcm = '"HKCU\Software\Classes\CLSID\{86CA1AA0-34AA-4E8B-A509-50C905BAE2A2}"'
$Srch = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Search"'
$Srhl = '"HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings"'
$Srdc = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB"'
$BwgM = '"HKCU\Software\Microsoft\Windows\Shell\BagMRU"'
$Bwgs = '"HKCU\Software\Microsoft\Windows\Shell\Bags"'
$Desk = '"HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop"'

#Keys for use with PowerShell
$ShPS = 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell'

#Keys for building REG files
$ImpR = '[HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\'
$DMR1 = '[HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\BagMRU]'
$DMR2 = '"NodeSlots"=hex:02'
$DMR3 = '"MRUListEx"=hex:ff,ff,ff,ff'
$DMR4 = '"NodeSlot"=dword:00000001'
$DMRU = "$DMR1`r`n$DMR2`r`n$DMR3`r`n$DMR4"

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
$ShellBak  = "$TempDir\ShellBak.reg"
$DeskBak   = "$TempDir\DeskBak.reg"
$TimeStr   = (get-date).ToString('yyyy-MM-dd-HHmm-ss')
$RegExe    = "$env:SystemRoot\System32\Reg.exe"
$CmdExe    = "$env:SystemRoot\System32\Cmd.exe"
$IcaclsExe = "$env:SystemRoot\System32\Icacls.exe"
$UAppData  = "$env:UserProfile\AppData"

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

Function ResetThumbCache {
  $ThumbCacheFiles = "$Env:LocalAppData\Microsoft\Windows\Explorer\thumbcache_*.db"
  & $IcaclsExe $ThumbCacheFiles /grant Everyone:F >$Null 2>$Null
  Remove-Item -Force -ErrorAction SilentlyContinue $ThumbCacheFiles
}

Function RestartExplorer {
  & $RegExe Import $ShellBak
  & $RegExe Import $DeskBak
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
  If ($KeepViews -eq 0) {& $RegExe Delete $Defs /f 2>$Null}
}

If ($FileExt -eq '.reg') {
  Write-Host `n'Restore from backup...'`n
}
Else {

  $iniContent = Get-IniContent $File
  $Reset = $iniContent['Options']['Reset']
  $KeepViews = [Int]$iniContent['Options']['KeepViews']
  $Generic = [Int]$iniContent['Options']['Generic']
  $NoFolderThumbs = [Int]$iniContent['Options']['NoFolderThumbs']
  $ResetThumbs = [Int]$iniContent['Options']['ResetThumbs']
  $UnhideAppData = [Int]$iniContent['Options']['UnhideAppData']
  $SearchOnly = [Int]$iniContent['Options']['SearchOnly']
  $SetVirtualFolders = [Int]$iniContent['Options']['SetVirtualFolders']
  $ThisPCoption = [Int]$iniContent['Options']['ThisPCoption']
  $ThisPCView = [Int]$iniContent['Options']['ThisPCView']
  $ThisPCNG = [Int]$iniContent['Options']['ThisPCNG']

  If ($Reset -eq 1) {
    Write-Host `n'Reset to Windows defaults...'`n
  }
  Else {
    Write-Host `n'Setting Explorer folder views...'`n
  }
}

# Create Exlorer folder view backup reg file

If (!(Test-Path -Path "$AppData\Backup")) {Mkdir "$AppData\Backup" >$Null}

# Backup current Desktop view details
& $RegExe Export $Desk $DeskBak /y 2>$Null
Add-Content -Path $DeskBak -Value $DMRU

Function RemoveTempFiles {
  Remove-Item $T1 2>$Null
  Remove-Item $T2 2>$Null
  Remove-Item $T3 2>$Null
  Remove-Item $T4 2>$Null
  Remove-Item $T5 2>$Null
  Remove-Item $T6 2>$Null
}

RemoveTempFiles

& $RegExe Delete $Desk /f 2>$Null
& $RegExe Export $BagM $T1 /y 2>$Null
& $RegExe Export $Bags $T2 /y 2>$Null
& $RegExe Export $Strm $T3 /y 2>$Null
& $RegExe Export $CUFT $T4 /y 2>$Null
& $RegExe Export $BwgM $T5 /y 2>$Null
& $RegExe Export $Bwgs $T6 /y 2>$Null

& $CmdExe /c Copy $T1+$T2+$T3+$T4+$T5+$T6 $BakFile >$Null 2>$Null

RemoveTempFiles

Remove-Item $ShellBak 2>$Null
Remove-Item -Path "$ShPS\*" -Recurse 2>$Null
Remove-ItemProperty -Path "$ShPS" -Name  Logo 2>$Null
Remove-ItemProperty -Path "$ShPS" -Name  FolderType 2>$Null
& $RegExe Export $Shel $ShellBak /y 2>$Null

# Clear current Explorer view registry values

DeleteUserKeys

# Restore from backup, restart Explorer, exit

If ($FileExt -eq '.reg') {
  & $RegExe Import $File
  RestartExplorer
}

# Set option to hide or show file extensions

$ShowExt = [Int]$iniContent['Options']['ShowExt']
& $RegExe Add $Advn /v HideFileExt /t REG_DWORD /d (1-$ShowExt) /f

# Set Windows 11 option to enable or disable compact view
# This value is ignored on older Windows versions

$CompView = [Int]$iniContent['Options']['CompView']
& $RegExe Add $Advn /v UseCompactMode /t REG_DWORD /d ($CompView) /f

# Enable/disable classic context menu in Windows 11
# This value is ignored on older Windows versions

$ClassicContextMenu = [Int]$iniContent['Options']['ClassicContextMenu']
If ($ClassicContextMenu -eq 1) {& $RegExe Add $Clcm"\InprocServer32" /reg:64 /f 2>$Null}
Else {& $RegExe Delete $Clcm /reg:64 /f 2>$Null}

# Turn off/on Internet in Windows search

$NoSearchInternet = [Int]$iniContent['Options']['NoSearchInternet']
$NoSearchInternet = 1-$NoSearchInternet
$NoSearchHighlights = [Int]$iniContent['Options']['NoSearchHighlights']
$NoSearchHighlights = 1-$NoSearchHighlights
& $RegExe Add $Srch /v BingSearchEnabled /t REG_DWORD /d ($NoSearchInternet) /f
& $RegExe Add $Srhl /v IsDynamicSearchBoxEnabled /t REG_DWORD /d ($NoSearchHighlights) /f
& $RegExe Add $Srdc /v ShowDynamicContent /t REG_DWORD /d ($NoSearchHighlights) /f

# Enable/disable folder thumbnails

If ($NoFolderThumbs -eq 1) {& $RegExe Add "$Shel" /v Logo /d none /t REG_SZ /f}

# Unhide / Hide AppData folder

If ($UnhideAppData -eq 1) {& $CmdExe /c attrib -h "$UAppData"}
Else {& $CmdExe /c attrib +h "$UAppData"}

# If reset, restart Explorer and exit

If ($Reset -eq 1) {
  & $RegExe Delete $Strm /f 2>$Null
  RestartExplorer
}

# Function to help Set up views for This PC

Function SetBagValues ($Key) {
  & $RegExe Add $Key /v LogicalViewMode /d $LVMode /t REG_DWORD /f >$Null
  & $RegExe Add $Key /v Mode /d $Mode /t REG_DWORD /f >$Null
  $Group = 1-$ThisPCNG
  & $RegExe Add $Key /v GroupView /d $Group /t REG_DWORD /f >$Null
  If ($LVMode -eq 3) {& $RegExe Add $Key /v IconSize /d $IconSize /t REG_DWORD /f >$Null}
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
  $Script:RegData += '"LogicalViewMode"=dword:' + $Script:LVMode + "`r`n"
  $Script:RegData += '"Mode"=dword:' + $Script:Mode + "`r`n"
  If ($Script:LVMode -eq 3) {$Script:RegData += '"IconSize"=dword:' + '{0:x}' -f $Script:IconSize + "`r`n"}
  $Group = 1-$FileDialogNG
  $Script:RegData += '"GroupView"=dword:' + $Group + "`r`n"
}

# The FolderTypes key does not include entries for This PC
# This PC does not have a unique GUID so we'll set it's view via a Bags entry:

If ($ThisPCoption -ne 0) {
  & $RegExe Add "$BagM" /v NodeSlots /d '02' /t REG_BINARY /f
  & $RegExe Add "$BagM" /v MRUListEx /d '00000000ffffffff' /t REG_BINARY /f >$Null
  & $RegExe Add "$BagM" /v '0' /d '14001F50E04FD020EA3A6910A2D808002B30309D0000' /t REG_BINARY /f >$Null
  & $RegExe Add "$BagM\0" /v NodeSlot /d 1 /t REG_DWORD /f >$Null
  $CustomIconSize = $iniContent['Generic']['IconSize']
  SetViewValues($ThisPCView)
  If ($CustomIconSize -ne '') {$IconSize = $CustomIconSize}
  $GUID = '{5C4F28B5-F869-4E84-8E60-F11DB97C5CC7}'
  SetBagValues("$Bags\1\ComDlg\$GUID")
  SetBagValues("$Bags\1\Shell\$GUID")
}

If ($Generic -eq 1) {& $RegExe Add "$Shel" /v FolderType /d Generic /t REG_SZ /f}

If ($SetVirtualFolders -eq 1) {
  $GUID = $iniContent['Generic']['GUID']
  $GroupBy = $iniContent['Generic']['GroupBy']
  $CustomIconSize = $iniContent['Generic']['IconSize']
  SetViewValues([Int]$iniContent['Generic']['View'])
  If ($CustomIconSize -ne '') {$IconSize = $CustomIconSize}
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

$RegData = "Windows Registry Editor Version 5.00`r`n`r`n"

Get-ChildItem $FolderTypes | Get-ItemProperty | ForEach {

  $FT = $_.CanonicalName
  If ($iniContent.ContainsKey($FT)) {
    $Include = [Int]$iniContent[$FT]['Include']
    
    If ($Include -eq 1) {

      $FileDialogOption = [Int]$iniContent[$FT]['FileDialogOption']
      $FileDialogView = [Int]$iniContent[$FT]['FileDialogView']
      $FileDialogNG = [Int]$iniContent[$FT]['FileDialogNG']

      If (($FileDialogOption -eq 1) -And ($FT -ne 'Global')) {
        $GUID = $iniContent[$FT]['GUID']
        SetViewValues($FileDialogView)
        BuildRegData('ComDlg')
        BuildRegData('ComDlgLegacy')
      }
      $GroupBy = $iniContent[$FT]['GroupBy']
      If ($GroupBy -ne '') {$GroupBy = "System.$GroupBy"}
      $GroupByOrder = $iniContent[$FT]['GroupByOrder']
      If ($GroupByOrder -eq '+') {$GroupByOrder = 1} Else {$GroupByOrder = 0}
      $SortBy = 'prop:' + $iniContent[$FT]['SortBy']
      $SortBy = $SortBy -Replace '\+','+System.'
      $SortBy = $SortBy -Replace '-','-System.'
      $View = $iniContent[$FT]['View']

      $CustomIconSize = $iniContent[$FT]['IconSize']
      SetViewValues($View)
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

If ($FileDialogOption -eq 1) {
  Out-File -InputObject $RegData -filepath $T1
  & $RegExe Import $T1
}

# Import Reg data for any custom settings

If (Test-Path -Path $Custom) {& $RegExe Import $Custom}

RestartExplorer
