Const ForWriting = 2
Const FontFolder = &H14
Set oFSO = CreateObject("Scripting.FileSystemObject")
Set oApp = CreateObject("Shell.Application")

RetVal = MsgBox("Click OK to create Fontlist.txt", vbOKCancel, Wscript.ScriptName)
If RetVal=vbCancel Then Wscript.Quit

' Get font names into dcitionary
Set oFonts = CreateObject("Scripting.Dictionary")
Set oFolder = oApp.Namespace(FontFolder)
Set oItems = oFolder.Items
For Each oItem In oItems
  oFonts.Add oItem.Name,""
Next

' Create array from dictionary
ArrFonts = oFonts.Keys

' Sort font name array
x = UBound(ArrFonts) - 1
For i = x To 0 Step -1
  For j= 0 To i
  If ArrFonts(j)>ArrFonts(j+1) Then
    y = ArrFonts(j+1)
    ArrFonts(j+1) = ArrFonts(j)
    ArrFonts(j) = y
  End If
  Next
Next

' Convert font name array into string list
FontList = Join(ArrFonts,vbCRLF)

' Save list to file
Set oFile = oFSO.OpenTextFile(".\Fontlist.txt",ForWriting,True)
oFile.Write FontList
oFile.Close

MsgBox "Fontlist.txt file created", vbInformation, Wscript.ScriptName

