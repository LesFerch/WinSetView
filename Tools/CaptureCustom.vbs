' This script captures keys that may contain settings beyond what can be set in WinSetView.
' The reg file created by this script can be renamed to WinSetViewCustom.reg and placed in the
' WinSetView AppData folder to provide additional custom settings.
' If you don't know what you're doing, please do not use this extra level of customization!

SetLocale(1033)
Const ForReading = 1
Const ForWriting = 2
Const Unicode = -1
Const Ansi = 0

Set oWSH = CreateObject("Wscript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")

Temp  = oWSH.ExpandEnvironmentStrings("%Temp%")
TempFile = Temp & "\WinSetView.tmp"
CaptureFile = ".\CaptureCustom.reg"

CPan = Chr(34) & "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" & Chr(34)
BagM = Chr(34) & "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" & Chr(34)
Bags = Chr(34) & "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" & Chr(34)

RetVal = MsgBox("This is an optional configuration tool for power users." & vbCRLF & vbCRLF & "Click OK to capture keys ControlPanel, BagMRU, and Bags to: " & CaptureFile, vbOKCancel, Wscript.ScriptName)
If RetVal=vbCancel Then Wscript.Quit

Set oOutput = oFSO.OpenTextFile(CaptureFile,ForWriting,True,Ansi)

oOutput.Write "Windows Registry Editor Version 5.00" & vbCRLF & vbCRLF
oOutput.Write "; Rename this file to WinSetViewCustom.reg to have it applied by WinSetView." & vbCRLF

oWSH.Run "Reg Export " & CPan & " " & TempFile & " /y",0,True

Set oInput = oFSO.OpenTextFile(TempFile,ForReading,,Unicode)
Do Until oInput.AtEndOfStream
  Line = oInput.ReadLine
  If Line<>"Windows Registry Editor Version 5.00" Then oOutput.Write Line & vbCRLF
Loop
oInput.Close

oWSH.Run "Reg Export " & BagM & " " & TempFile & " /y",0,True

Set oInput = oFSO.OpenTextFile(TempFile,ForReading,,Unicode)
Do Until oInput.AtEndOfStream
  Line = oInput.ReadLine
  If Line<>"Windows Registry Editor Version 5.00" Then oOutput.Write Line & vbCRLF
Loop
oInput.Close

oWSH.Run "Reg Export " & Bags & " " & TempFile & " /y",0,True

Set oInput = oFSO.OpenTextFile(TempFile,ForReading,,Unicode)
Do Until oInput.AtEndOfStream
  Line = oInput.ReadLine
  If InStr(Line,"\AllFolders") Then Exit Do
  If Line<>"Windows Registry Editor Version 5.00" Then oOutput.Write Line & vbCRLF
Loop
oInput.Close

oOutput.Close

MsgBox "Done. See file: " & CaptureFile, vbInformation, Wscript.ScriptName
