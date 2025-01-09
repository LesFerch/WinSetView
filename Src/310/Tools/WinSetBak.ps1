#  Powershell script that will backup and restore user Explorer view settings.
#  This backup captures more than the backup built into WinSetView.
#  For a GUI-less restore, simply go to Cmd line and run Reg Import YourSettings.reg
#  where YourSettings.reg is the settings file captured with the backup option.

If ($PSVersionTable.PSVersion.Major -lt 3) {
  Write-Host `n'Powershell 3 or higher is required.'`n
  Read-Host -Prompt "Press any key to continue"
  Exit
}

Set-StrictMode -Off
#$ExecutionContext.SessionState.LanguageMode = "ConstrainedLanguage"
$Constrained = $false
$MyName = "Folder View Backup"
If ($ExecutionContext.SessionState.LanguageMode -eq "ConstrainedLanguage") {$Constrained = $true}
If (-Not $Constrained) {$host.ui.RawUI.WindowTitle = $MyName}

$BakDir   = "$env:APPDATA\WinViewBak"
$TimeStr  = (get-date).ToString("yyyy-MM-dd-HHmm-ss")
$TestFile = "$PSScriptRoot\$TimeStr.txt"
$TempDir  = "$env:TEMP"

$RegExe    = "$env:SystemRoot\System32\Reg.exe"

$regCheck = & $RegExe query HKU 2>$Null
if ($regCheck -eq $Null) {
  $RegExe = "..\AppParts\CSReg.exe"
  If (-Not(Test-Path -Path $RegExe)) {
    Write-Host `n"File not found: $RegExe"`n
    Read-Host -Prompt 'Press Enter to continue'
    Exit
  }
}

Try {[io.file]::OpenWrite($TestFile).close()}
Catch {}
If (Test-Path -Path $TestFile) {
  Remove-Item $TestFile
  $BakDir = "$PSScriptRoot\WinViewBak"
}

Function SetDPIAwareness {
    Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        public class DpiAwareness {
            [DllImport("user32.dll")]
            public static extern bool SetProcessDPIAware();
        }
"@
    [DpiAwareness]::SetProcessDPIAware()
}

SetDPIAwareness

Function SelectFolder {       

  Add-Type -AssemblyName System.Windows.Forms

  $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
  $FolderBrowser.Description = "Select backup folder..."
  $FolderBrowser.ShowNewFolderButton = $True
  $FolderBrowser.SelectedPath = $BakDir

  $Handle = [System.Windows.Forms.NativeWindow]::New()
  $Handle.AssignHandle([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

  $Button = $FolderBrowser.ShowDialog($Handle)
  If ($Button -eq "OK") {$BakDir = $FolderBrowser.SelectedPath}

  Return $BakDir
}

Function SelectFile {       

  Add-Type -AssemblyName System.Windows.Forms

  $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = $BakDir 
    Filter = 'Registration Files (*.reg)|*.reg'
    Multiselect = $True
    Title = 'Select registry file to restore...'
  }

  $Handle = [System.Windows.Forms.NativeWindow]::New()
  $Handle.AssignHandle([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

  $File = ''
  $Button = $FileBrowser.ShowDialog($Handle)
  If ($Button -eq "OK") {$File = $FileBrowser.FileName}

  Return $File
}

$RegKeys = @(
'HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU'
'HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags'
'HKCU\Software\Microsoft\Windows\Shell\BagMRU'
'HKCU\Software\Microsoft\Windows\Shell\Bags'
'HKCU\Software\Microsoft\Windows\ShellNoRoam\BagMRU'
'HKCU\Software\Microsoft\Windows\ShellNoRoam\Bags'
'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CIDOpen'
'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CIDSave'
'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32'
'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Modules\NavPane'
'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer'
'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams'
'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes'
'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel'
'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
)

Function DeleteUserKeys {
  ForEach ($Key in $RegKeys) {
    & $RegExe Delete $Key /F 2>$Null
  }
}

Function DeleteTempFiles {
  For ($i = 0; $i -lt $RegKeys.Length; $i++) {
    Remove-Item "$TempDir\WinViewBak$i.tmp" 2>$Null
  }
}

Function RestartExplorer {
  Write-Host 'Press Enter to restart Explorer and apply settings.'`n
  Pause
  Get-process explorer | Stop-Process
  Exit
}

While($True){

  Clear-Host
  Write-Host ''
  Write-Host "1. Select backup folder (Current: $BakDir)"
  Write-Host "2. Create a backup of current Explorer folder views"
  Write-Host "3. Restore Explorer folder views from backup file"
  Write-Host "4. Clear current Explorer views and return to Windows defaults"

  $Mode = Read-Host `n'Choose option or press Enter to Exit'

  Switch($Mode){
  
    ""{Write-Host ''; Exit}
    
    # Folder
    "1"{
      $BakDir = SelectFolder
    }

    # Backup
    "2"{

      If (!(Test-Path -Path $BakDir)) {Mkdir $BakDir >$Null}

      If (-Not (Test-Path -Path $BakDir)) {Write-Host `n'Backup folder could not be created.'`n; Pause; Exit}

      DeleteTempFiles
      
      Write-Host ''

      $TimeStr  = (get-date).ToString("yyyy-MM-dd-HHmm-ss")
      $BakFile  = "$BakDir\$TimeStr.reg"

      For ($i = 0; $i -lt $RegKeys.Length; $i++) {
        $File = "$TempDir\WinViewBak$i.tmp"
        & $RegExe Export $RegKeys[$i] $File /y 2>$Null
        If (Test-Path -Path $File) {$FileList = $FileList + "+$TempDir\WinViewBak$i.tmp"}
      }

      Cmd /c Copy $FileList.Trim('+') $BakFile >$Null 2>$Null
      
      DeleteTempFiles
      
      Write-Host `n'Backup complete.'`n
      Pause
    }

    # Restore
    "3"{
      If (-Not (Test-Path -Path $BakDir)) {Write-Host `n'Backup folder does not exist.'`n; Pause; Continue}

      $Count = (Get-ChildItem "$BakDir\*.reg" -file | Measure-Object).Count
      If ($Count -eq 0) {Write-Host `n'No reg files found in backup folder.'`n; Pause; Continue}
      
      $File = SelectFile
      If ($File -eq '') {Continue}

      Write-Host ''
      DeleteUserKeys
      & $RegExe Import $File
      Write-Host `n'Restore complete.'`n
      RestartExplorer
    }

    # Clear
    "4"{
      $Count = 0
      If (Test-Path -Path $BakDir) {
        $Count = (Get-ChildItem "$BakDir\*.reg" -file | Measure-Object).Count
      }
      If ($Count -eq 0) {
        $Conf = Read-Host `n"Are you sure you want to clear settings without a backup?"
        if ($Conf -ne 'y') {Continue}
      }  
      Write-Host ''
      DeleteUserKeys
      Write-Host `n'Clear complete.'`n
      RestartExplorer
    }
  }
}