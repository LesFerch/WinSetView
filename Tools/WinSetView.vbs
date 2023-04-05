'INIFile = ".\Win10.ini"
If WScript.Arguments.Count>0 Then INIFile = WScript.Arguments.Item(0)
Set oShell = CreateObject("Wscript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")
MyPath = Wscript.ScriptFullName
MyPath = Left(MyPath,InStrRev(MyPath,"\"))
oShell.CurrentDirectory = MyPath

If Not oFSO.FileExists(INIFile) Then
  Msg = "Run WinSetView.exe to create or update INI file." & vbCRLF & vbCRLF
  Msg = Msg & "Then drop INI file on this script to run "
  Msg = Msg & "WinSetView.ps1 with the saved settings." & vbCRLF & vbCRLF
  Msg = Msg & "This script can be relocated to the WinSetView AppData folder."
  MsgBox Msg,0+64,"GUI-less Execution Instructions:"
Else
  CmdLine = "Powershell.exe -ExecutionPolicy Bypass ..\WinSetView.ps1 " & INIFile
  oShell.Run CmdLine,1,False
End If
