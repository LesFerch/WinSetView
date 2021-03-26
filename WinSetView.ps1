# WinSetView (Globally Set Explorer Folder Views)
# Les Ferch, lesferch@gmail.com, GitHub repository created 2021-03-26
# File 2 of 2: WinSetView.ps1 (Powershell script to set selected views)

# $Mode:    View Settings for all folders except "This PC" and "Network":
#           1 = Details View  4 = List View     2 = Tiles View   5 = Content View
#           3 = Small Icons   6 = Medium Icons  7 = Large Icons  8 = Extra Large Icons
#           0 = Reset all views to Windows defaults, including "This PC" and "Network"
#           9 = Restore views from backup file

# $ShowExt: 1 = Show file extensions  0 = Hide file extensions
# $NoGroup: 1 = No grouping  0 = Windows default grouping
# $Generic: 1 = Make all folders generic  0 = Windows default folder identities

# $TPMode:  View Settings for "This PC" and "Network":
#           1 = Details View  4 = List View     2 = Tiles View   5 = Content View
#           3 = Small Icons   6 = Medium Icons  7 = Large Icons  8 = Extra Large Icons
#           0 = Windows default views

# $TPNoGrp: For "This PC" and "Network": 1 = No groups  0 = Windows default groups

# $Columns: 1 = Set global column headings  0 = Windows default columns
# $ColShow: Columns to display in detail view
# $ColMore: Additional columns available to select via right-click

Param (
  $Mode = 1,
  $ShowExt = 1,
  $NoGroup = 1,
  $Generic = 1,
  $TPMode = 4,
  $TPNoGrp = 1,
  $Columns = 1,
  $ColShow = 'DateModified,Size,ItemType',
  $ColMore = 'FileExtension,ItemTypeText,ContentType,PerceivedType,Kind,DateCreated,DateAccessed,FileAttributes,FileVersion,ItemFolderNameDisplay,ItemFolderPathDisplay,ItemFolderPathDisplayNarrow,ItemPathDisplay'
)

If ($Mode -IsNot [int]) {$Mode = 1}
If ($ShowExt -IsNot [int]) {$ShowExt = 1}
If ($NoGroup -IsNot [int]) {$NoGroup = 1}
If ($Generic -IsNot [int]) {$Generic = 1}
If ($TPMode -IsNot [int]) {$TPMode = 4}
If ($TPNoGrp -IsNot [int]) {$TPNoGrp = 1}
If ($Columns -IsNot [int]) {$Columns = 0}

If ($Mode -gt 9) {$Mode = 1}
If ($ShowExt -gt 1) {$ShowExt = 1}
If ($TPMode -gt 8) {$TPMode = 4}

If ($Mode -eq 3) {$IconSize = '010'}
If ($Mode -eq 6) {$Mode = 3; $IconSize = '030'}
If ($Mode -eq 7) {$Mode = 3; $IconSize = '060'}
If ($Mode -eq 8) {$Mode = 3; $IconSize = '100'}

$ColShow  = (';0System.' + $ColShow -replace ',',';0System.')
$ColMore  = (';1System.' + $ColMore -replace ',',';1System.')
$ColReg   = ('"ColumnList"="prop:0System.ItemNameDisplay' + $ColShow + $ColMore)

$BagM = '"HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU"'
$Bags = '"HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags"'
$AFSh = '"HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell"'
$Defs = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults"'
$CUFT = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes"'
$LMFT = '"HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes"'
$Advn = '"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"'

$LV       = '"LogicalViewMode"=dword:0000000'
$IS       = '"IconSize"=dword:00000'
$TempDir  = "$env:TEMP"
$BakDir   = "$env:APPDATA\WinSetView"
$RegFile  = "$TempDir\WinSetView.reg"
$T1       = "$TempDir\WinSetView.tmp"
$TimeStr  = (get-date).ToString("yyyy-MM-dd-HHmm-ss")
$BakFile  = "$BakDir\$TimeStr.reg"
$Bak      = $Null

Function DeleteUserKeys {
  Reg Delete $BagM /f 2>$Null
  Reg Delete $Bags /f 2>$Null
  Reg Delete $Defs /f 2>$Null
}

Function RestartExplorer {
  Get-process explorer | Stop-Process
  Exit
}

#Restore Exlorer folder views from backup reg file

If ($Mode -eq 9) {
  If (-Not (Test-Path -Path $BakDir)) {Write-Host `n'Backup folder does not exist.'`n; Pause; Exit}

  $Count = (Get-ChildItem "$BakDir\*.reg" -file | Measure-Object).Count
  If ($Count -eq 0) {Write-Host `n'No reg files found in backup folder.'`n; Pause; Exit}

  Add-Type -AssemblyName System.Windows.Forms
  $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
      InitialDirectory = $BakDir 
      Filter = 'Registration Files (*.reg)|*.reg'
      Multiselect = $True
      Title = 'Select registry file to restore...'
  }
  $Button = $FileBrowser.ShowDialog()
  $File = $FileBrowser.FileName
  If ($Button -eq "Cancel") {Exit}
  DeleteUserKeys
  Reg Import $File
  RestartExplorer
}

#Create Exlorer folder view backup reg file

If (!(Test-Path -Path $BakDir)) {Mkdir $BakDir}

Remove-Item $T1 2>$Null; Reg Export $BagM $T1 /y 2>$Null; If (Test-Path -Path $T1) {$Bak = $Bak + (Get-Content $T1 -Raw)}
Remove-Item $T1 2>$Null; Reg Export $Bags $T1 /y 2>$Null; If (Test-Path -Path $T1) {$Bak = $Bak + (Get-Content $T1 -Raw)}
Remove-Item $T1 2>$Null; Reg Export $Defs $T1 /y 2>$Null; If (Test-Path -Path $T1) {$Bak = $Bak + (Get-Content $T1 -Raw)}
Remove-Item $T1 2>$Null

If ($Bak -ne $Null) {Out-File -InputObject $Bak -filepath $BakFile}

#Clear current Explorer view registry values

DeleteUserKeys
Reg Delete $CUFT /f 2>$Null

#Set option to hide or show file extensions

Reg Add $Advn /v HideFileExt /t REG_DWORD /d (1-$ShowExt) /f

#If returning to Explorer defaults, restart Explorer and exit

If ($Mode -eq 0) {RestartExplorer}

#Function to help Set up views for "This PC" and "Network" virtual folders

Function SetBagValues ($Key) {
  Reg Add $Key /v LogicalViewMode /d $TPMode /t REG_DWORD /f
  Reg Add $Key /v Mode /d $TPXMode /t REG_DWORD /f
  If ($TPNoGrp -eq 1) {Reg Add $Key /v GroupView /d 0 /t REG_DWORD /f}
  If ($TPMode -eq 3) {Reg Add $Key /v IconSize /d $TPIcon /t REG_DWORD /f}
}

#Set up views for "This PC" and "Network" virtual folders

If ($TPMode -ne 0) {

  # The FolderTypes key does not have default values for "This PC" and "Network",
  # so we will set them with initial values in the BagMRU and Bags registry keys.

  Reg Add "$BagM" /v NodeSlots /d "020202" /t REG_BINARY /f
  Reg Add "$BagM" /v MRUListEx /d "0100000000000000ffffffff" /t REG_BINARY /f
  Reg Add "$BagM" /v "0" /d "14001F50E04FD020EA3A6910A2D808002B30309D0000" /t REG_BINARY /f
  Reg Add "$BagM" /v "1" /d "14001F580D1A2CF021BE504388B07367FC96EF3C0000" /t REG_BINARY /f
  Reg Add "$BagM\0" /v NodeSlot /d 1 /t REG_DWORD /f
  Reg Add "$BagM\1" /v NodeSlot /d 2 /t REG_DWORD /f

  If ($TPMode -eq 1) {$TPXMode = 4}
  If ($TPMode -eq 4) {$TPXMode = 3}
  If ($TPMode -eq 2) {$TPXMode = 6}
  If ($TPMode -eq 5) {$TPXMode = 8}
  If ($TPMode -eq 3) {$TPXMode = 1; $TPIcon = 16}
  If ($TPMode -eq 6) {$TPMode = 3; $TPXMode = 1; $TPIcon = 48}
  If ($TPMode -eq 7) {$TPMode = 3; $TPXMode = 1; $TPIcon = 96}
  If ($TPMode -eq 8) {$TPMode = 3; $TPXMode = 1; $TPIcon = 256}

  $GUID = "{5C4F28B5-F869-4E84-8E60-F11DB97C5CC7}"
  SetBagValues("$Bags\1\ComDlg\$GUID")
  SetBagValues("$Bags\1\Shell\$GUID")
  If (!($Generic -eq 1)) {$GUID = "{25CC242B-9A7C-4F51-80E0-7A2928FEBE42}"}
  SetBagValues("$Bags\2\ComDlg\$GUID")
  SetBagValues("$Bags\2\Shell\$GUID")
}

If ($Generic -eq 1) {Reg Add $AFSh /v FolderType /d Generic /t REG_SZ /f}

#Set Explorer folder view defaults. Steps:
# 1) Export HKLM FolderTypes key
# 2) Use Replace with regular expresions to change defaults in exported file
# 3) Import FolderTypes key to HKCU
# 4) Restart Explorer
#Note: Explorer will use HKCU key instead of HKLM key automatically

Reg Export $LMFT $RegFile /y

$Data = Get-Content $RegFile

$Data = $Data -replace 'HKEY_LOCAL_MACHINE','HKEY_CURRENT_USER'
$Data = $Data -replace ($LV+'.+'),($LV+$Mode)
If ($Mode -eq 3) {
  $Data = $Data -replace ($IS+".+"),''
  $Data = $Data -replace ($LV+$Mode),($IS+$IconSize+[char]13+[char]10+$LV+$Mode)
}
If ($NoGroup -eq 1) {$Data = $Data -replace '"GroupBy"=".+"','"GroupBy"=""'}
If ($Columns -eq 1) {$Data = $Data -replace '"ColumnList"=".+?(?=;1)',$ColReg}

Out-File -InputObject $Data -encoding ASCII -filepath $RegFile

Reg Import $RegFile

RestartExplorer
