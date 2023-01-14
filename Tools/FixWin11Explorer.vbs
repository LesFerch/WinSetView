Set oWSH = WScript.CreateObject("WScript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")

CurBld = oWSH.RegRead("HKLM\Software\Microsoft\Windows NT\CurrentVersion\CurrentBuild")
If CurBld<22000 Or CurBld>=25000 Then
  MsgBox "Not supported on this build",vbInformation,"Notice"
  WScript.Quit
End If

If Not WScript.Arguments.Named.Exists("elevate") Then
  CreateObject("Shell.Application").ShellExecute WScript.FullName, """" & WScript.ScriptFullName & """ /elevate", "", "runas", 1
  WScript.Quit
End If

RegShellValue = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell"
SystemRoot = oWSH.ExpandEnvironmentStrings("%SYSTEMROOT%")
Z = VBCRLF
B1 = vbInformation + vbOKCancel

Response = MsgBox("Click Yes for previous Windows style (if available)" & Z & Z & "Click No for the Windows default",vbYesNoCancel,"Select your preferred Explorer ribbon")

Sub RestartExplorer
  If Response = vbOK Then
    oWSH.Run "Powershell.exe -ExecutionPolicy Bypass -Command Get-process explorer | Stop-Process",0,True
    oWSH.Run "Explorer.exe",1,False
  End If
End Sub

If Response = vbYes Then
  Set oExec = oWSH.Exec("fsutil hardlink list " & SystemRoot & "\explorer.exe")
  Do While Not oExec.StdOut.AtEndOfStream
    StdOut = Trim(oExec.StdOut.ReadLine)
    If InStr(1,StdOut,"winsxs",1)>0 Then Exit Do
  Loop
  StdOut = Trim(Replace(StdOut, "\windows\WinSxS", SystemRoot & "\WinSxS"))
  If oFSO.FileExists (StdOut) Then
    oWSH.RegWrite RegShellValue, StdOut, "REG_SZ"
    Response = MsgBox("The following file is now set as the shell:" & Z & Z & StdOut & Z & Z & "Click OK to restart Explorer now",B1,"Notice")
    RestartExplorer
  Else
    MsgBox "File not found:" & Z & Z & StdOut,,"Error"
  End If
End If

If Response = vbNo Then
  oWSH.RegWrite RegShellValue, "Explorer.exe", "REG_SZ"
  Response = MsgBox("The shell is now set to Explorer.exe" & Z & Z & "Click OK to restart Explorer now",B1,"Notice")
  RestartExplorer
End If
