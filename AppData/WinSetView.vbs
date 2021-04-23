'ParamFile = ".\WinSetViewParams.txt"
If WScript.Arguments.Count>0 Then ParamFile = WScript.Arguments.Item(0)
Set oShell = CreateObject("Wscript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")
MyPath = Wscript.ScriptFullName
MyPath = Left(MyPath,InStrRev(MyPath,"\"))
oShell.CurrentDirectory = MyPath

If Not oFSO.FileExists(ParamFile) Then
  Msg = "Run WinSetView.hta to create or update WinSetViewParams.txt." & vbCRLF & vbCRLF
  Msg = Msg & "Then drop WinSetViewParams.txt (or a renamed copy) "
  Msg = Msg & "on this script to run WinSetView.ps1 with the "
  Msg = Msg & "saved parameters."
  MsgBox Msg,0+64,"GUI-less Execution Instructions:"
Else
  Set oFile = oFSO.OpenTextFile(ParamFile,1)
  Params = oFile.ReadLine
  oFile.Close
  CmdLine = "Powershell.exe -ExecutionPolicy Bypass " & Chr(34) & "..\WinSetView.ps1" & Chr(34) & " " & Params
  oShell.Run CmdLine,1,False
End If
