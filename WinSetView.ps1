# WinSetView (Globally Set Explorer Folder Views)
# Les Ferch, lesferch@gmail.com, GitHub repository created 2021-03-26
# WinSetView.ps1 (Powershell script to set selected views)

# One command line paramater is supported
# Provide INI file name to set Explorer views
# Provide REG file name to restore Explorer views from backup

Param (
  $File = ''
)

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

# Get Windows major version from ProductName value
# Treat Windows 11 same as Windows 10 because they 
# have same folder types and properties

$Key = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion'
$Value = 'ProductName'
$WinVer = (Get-ItemProperty -Path $Key -Name $Value).$Value.SubString(8,2)
$WinVer = '   .' + $WinVer + '. '
$WinVer = ($WinVer -Replace '\.',' ').Trim()
If ($WinVer -eq '11') {$WinVer = '10'}

If (($WinVer -ne '7') -And ($WinVer -ne '8') -And ($WinVer -ne '10')){
  Write-Host `n'Windows 7, 8, 10 or 11 is required.'`n
  Read-Host -Prompt 'Press any key to continue'
  Exit
}

# Windows 7 includes Powershell 2 so this check should never fail

If ($PSVersionTable.PSVersion.Major -lt 2) {
  Write-Host `n'Powershell 2 or higher is required.'`n
  Read-Host -Prompt 'Press any key to continue'
  Exit
}

# Verify INI or REG file is supplied on the command line

$FileExt = ''
If ($File.Length -gt 4) {$FileExt = $File.SubString($File.Length-4)}

If (-Not(($FileExt -eq '.ini') -Or ($FileExt -eq '.reg'))) {
  Write-Host `n'No INI or REG file supplied on command line.'`n
  Read-Host -Prompt 'Press any key to continue'
  Exit
}

If (-Not(Test-Path -Path $File)) {
  Write-Host `n"File not found: $File"`n
  Read-Host -Prompt 'Press any key to continue'
  Exit
}

$BagM = '"HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU"'
$Bags = '"HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags"'
$Defs = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults"'
$CUFT = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes"'
$LMFT = '"HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes"'
$Advn = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"'
$ImpR = '[HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\'

$TempDir  = "$env:TEMP"
$AppData  = "$env:APPDATA\WinSetView"
$RegFile1 = "$TempDir\WinSetView1.reg"
$RegFile2 = "$TempDir\WinSetView2.reg"
$T1       = "$TempDir\WinSetView1.tmp"
$T2       = "$TempDir\WinSetView2.tmp"
$T3       = "$TempDir\WinSetView3.tmp"
$T4       = "$TempDir\WinSetView4.tmp"
$TimeStr  = (get-date).ToString('yyyy-MM-dd-HHmm-ss')

# Create PSScriptRoot variable if not exist (i.e. PowerShell 2)

If (!$PSScriptRoot) {$PSScriptRoot = Split-Path $Script:MyInvocation.MyCommand.Path -Parent}

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

Function RestartExplorer {
  Get-process explorer | Stop-Process
  Explorer $PSScriptRoot
  Exit
}

Function DeleteUserKeys {
  Reg Delete $BagM /f 2>$Null
  Reg Delete $Bags /f 2>$Null
  Reg Delete $CUFT /f 2>$Null
  If ($KeepViews -eq 0) {Reg Delete $Defs /f 2>$Null}
}

If ($FileExt -eq '.reg') {
  Write-Host `n'Restore from backup...'`n
}
Else {

  $iniContent = Get-IniContent $File
  $Reset = $iniContent['Options']['Reset']
  $KeepViews = [Int]$iniContent['Options']['KeepViews']
  $Generic = [Int]$iniContent['Options']['Generic']
  $SearchOnly = [Int]$iniContent['Options']['SearchOnly']
  $SetVirtualFolders = [Int]$iniContent['Options']['SetVirtualFolders']
  $FileDialogOption = [Int]$iniContent['Options']['FileDialogOption']
  $FileDialogView = [Int]$iniContent['Options']['FileDialogView']
  $FileDialogNG = [Int]$iniContent['Options']['FileDialogNG']
  $ThisPCoption = [Int]$iniContent['Options']['ThisPCoption']
  $ThisPCView = [Int]$iniContent['Options']['ThisPCView']
  $ThisPCNG = [Int]$iniContent['Options']['ThisPCNG']
  $NetworkOption = [Int]$iniContent['Options']['NetworkOption']
  $NetworkView = [Int]$iniContent['Options']['NetworkView']
  $NetworkNG = [Int]$iniContent['Options']['NetworkNG']

  If ($Reset -eq 1) {
    Write-Host `n'Reset to Windows defaults...'`n
  }
  Else {
    Write-Host `n'Setting Explorer folder views...'`n
  }
}

# Create Exlorer folder view backup reg file

If (!(Test-Path -Path "$AppData\Backup")) {Mkdir "$AppData\Backup" >$Null}

Remove-Item $T1 2>$Null
Remove-Item $T2 2>$Null
Remove-Item $T3 2>$Null
Remove-Item $T4 2>$Null

Reg Export $BagM $T1 /y 2>$Null
Reg Export $Bags $T2 /y 2>$Null
Reg Export $Defs $T3 /y 2>$Null
Reg Export $CUFT $T4 /y 2>$Null

Cmd /c Copy $T1+$T2+$T3+$T4 $BakFile >$Null 2>$Null

Remove-Item $T1 2>$Null
Remove-Item $T2 2>$Null
Remove-Item $T3 2>$Null
Remove-Item $T4 2>$Null

# Clear current Explorer view registry values

DeleteUserKeys

# Restore from backup, restart Explorer, exit

If ($FileExt -eq '.reg') {
  Reg Import $File
  RestartExplorer
}

# Set option to hide or show file extensions

$ShowExt = [Int]$iniContent['Options']['ShowExt']
Reg Add $Advn /v HideFileExt /t REG_DWORD /d (1-$ShowExt) /f

# Set Windows 11 option to enable or disable compact view
# This value is ignored on older Windows versions

$CompView = [Int]$iniContent['Options']['CompView']
Reg Add $Advn /v UseCompactMode /t REG_DWORD /d ($CompView) /f

# If reset, restart Explorer and exit

If ($Reset -eq 1) {RestartExplorer}

# Function to help Set up views for This PC and Network virtual folders

Function SetBagValues ($Key) {
  Reg Add $Key /v LogicalViewMode /d $LVMode /t REG_DWORD /f >$Null
  Reg Add $Key /v Mode /d $Mode /t REG_DWORD /f >$Null
  If ($ThisPCNG -eq 1) {Reg Add $Key /v GroupView /d 0 /t REG_DWORD /f >$Null}
  If ($LVMode -eq 3) {Reg Add $Key /v IconSize /d $IconSize /t REG_DWORD /f >$Null}
}

# Set view values based on selection index

Function SetViewValues($Index) {
  If ($Index -eq 1) {$Script:LVMode = 1; $Script:Mode = 4}
  If ($Index -eq 2) {$Script:LVMode = 4; $Script:Mode = 3}
  If ($Index -eq 3) {$Script:LVMode = 2; $Script:Mode = 6}
  If ($Index -eq 4) {$Script:LVMode = 5; $Script:Mode = 8}
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
}

# The FolderTypes key does not include entries for This PC and Network

# This PC does not have a unique GUID so we'll set it's view via a Bags entry:

If ($ThisPCoption -ne 0) {
  Reg Add "$BagM" /v NodeSlots /d '02' /t REG_BINARY /f
  Reg Add "$BagM" /v MRUListEx /d '00000000ffffffff' /t REG_BINARY /f >$Null
  Reg Add "$BagM" /v '0' /d '14001F50E04FD020EA3A6910A2D808002B30309D0000' /t REG_BINARY /f >$Null
  Reg Add "$BagM\0" /v NodeSlot /d 1 /t REG_DWORD /f >$Null
  SetViewValues($ThisPCView)
  $GUID = '{5C4F28B5-F869-4E84-8E60-F11DB97C5CC7}'
  SetBagValues("$Bags\1\ComDlg\$GUID")
  SetBagValues("$Bags\1\Shell\$GUID")
}

# Network has a unique GUID, so we'll set it's view via an AllFolders entry:

If ($NetworkOption -ne 0) {
  $GUID = '{25CC242B-9A7C-4F51-80E0-7A2928FEBE42}'
  SetViewValues($NetworkView)
  Reg Add "$Bags\AllFolders\Shell\$GUID" /v Mode /d "$Mode" /t REG_DWORD /f
  Reg Add "$Bags\AllFolders\Shell\$GUID" /v LogicalViewMode /d "$LVMode" /t REG_DWORD /f
  If ($LVMode -eq 3) {Reg Add "$Bags\AllFolders\Shell\$GUID" /v IconSize /d "$IconSize" /t REG_DWORD /f}
  If ($NetworkNG -eq 1) {Reg Add "$Bags\AllFolders\Shell\$GUID" /v GroupView /d 0 /t REG_DWORD /f}
}

If ($Generic -eq 1) {Reg Add "$Bags\AllFolders\Shell" /v FolderType /d Generic /t REG_SZ /f}

If ($SetVirtualFolders -eq 1) {
  $GUID = $iniContent['Generic']['GUID']
  $GroupBy = $iniContent['Generic']['GroupBy']
  SetViewValues([Int]$iniContent['Generic']['View'])
  Reg Add "$Bags\AllFolders\Shell\$GUID" /v Mode /d "$Mode" /t REG_DWORD /f
  Reg Add "$Bags\AllFolders\Shell\$GUID" /v LogicalViewMode /d "$LVMode" /t REG_DWORD /f
  If ($LVMode -eq 3) {Reg Add "$Bags\AllFolders\Shell\$GUID" /v IconSize /d "$IconSize" /t REG_DWORD /f}
  If ($GroupBy -eq '') {Reg Add "$Bags\AllFolders\Shell\$GUID" /v GroupView /d 0 /t REG_DWORD /f}
}

# Set Explorer folder view defaults:
#  1) Export HKLM FolderTypes key
#  2) Import FolderTypes key to HKCU
#  2) Update HKCU FolderTypes default settings
#  4) Restart Explorer
# Note: Explorer will use HKCU key instead of HKLM key automatically

# Copy FolderType key from HKLM to HKCU by exporting and importing

Reg Export $LMFT $RegFile1 /y
$Data = Get-Content $RegFile1
$Data = $Data -Replace 'HKEY_LOCAL_MACHINE','HKEY_CURRENT_USER'
Out-File -InputObject $Data -encoding Unicode -filepath $RegFile1
Reg Import $RegFile1

$FolderTypes = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes'

# Create lookup table for path type properties so these can be excluded from
# non-search views if the search-only option is enabled

$PathItems = @{
  'ItemFolderPathDisplay' = ''
  'ItemFolderPathDisplayNarrow' = ''
  'ItemPathDisplay' = ''
  'ItemFolderNameDisplay' = ''
}

If ($FileDialogOption -eq 1) {$RegData = "Windows Registry Editor Version 5.00`r`n`r`n"}

Get-ChildItem $FolderTypes | Get-ItemProperty | ForEach {

  $FT = $_.CanonicalName
  If ($iniContent.ContainsKey($FT)) {
    $Include = [Int]$iniContent[$FT]['Include']
    
    If ($Include -eq 1) {
      If (($FileDialogOption -eq 1) -And ($FT -ne 'Global')) {
        $GUID = $iniContent[$FT]['GUID']
        SetViewValues($FileDialogView)
        BuildRegData('ComDlg')
        BuildRegData('ComDlgLegacy')
      }
      $GroupBy = $iniContent[$FT]['GroupBy']
      If ($GroupBy -ne '') {$GroupBy = "System.$GroupBy"}
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
          If ($LVMode -eq 3)  {Set-ItemProperty -Path $ChildKey -Name 'IconSize' -Value $IconSize}
          Set-ItemProperty -Path $ChildKey -Name 'GroupBy' -Value $GroupBy
          Set-ItemProperty -Path $ChildKey -Name 'SortByList' -Value $SortBy
          Set-ItemProperty -Path $ChildKey -Name 'ColumnList' -Value $ColumnList
        }
      }
    }
  }
}

# Export results for use with comparison tools such as WinDiff

Reg Export $CUFT $RegFile2 /y

# Import Reg data to force dialog views
# This is MUCH faster than creating the keys using PowerShell

If ($FileDialogOption -eq 1) {
  Out-File -InputObject $RegData -filepath $T1
  Reg Import $T1
}

# Import Reg data for any custom settings

If (Test-Path -Path $Custom) {Reg Import $Custom}

RestartExplorer
