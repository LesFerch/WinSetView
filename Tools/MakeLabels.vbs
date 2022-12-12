SetLocale(1033)
Const ForReading = 1
Const ForWriting = 2
Const Unicode = -1

Set oWSH = CreateObject("Wscript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")
Set oHTTP = CreateObject("Microsoft.XMLHTTP")

Lang = oWSH.RegRead("HKCU\Control Panel\Desktop\PreferredUILanguages")(0)
Lang = InputBox("Language:",Wscript.ScriptName,Lang)
If Lang="" Then Wscript.Quit

If LCase(Lang)="en-us" Then
  MsgBox "This script requires en-US Labels.txt to already exist.", vbCritical, Wscript.ScriptName
  Wscript.Quit
End If

RetVal = MsgBox("Click OK to make Labels file for: " & Lang, vbOKCancel, Wscript.ScriptName)
If RetVal=vbCancel Then Wscript.Quit

LangPath = "..\Language\" & Lang
If Not oFSO.FolderExists(LangPath) Then oFSO.CreateFolder(LangPath)
LabelFile = LangPath & "\Labels.txt"

Set oFile = oFSO.OpenTextFile("..\Language\en-US\Labels.txt",ForReading,,Unicode)
English = oFile.ReadAll
oFile.Close
English = Replace(English,vbCRLF,"%0D")

URL = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=" & Lang & "&dt=t&q=" & English

oHTTP.Open "Get", URL, False
oHTTP.Send
Response = oHTTP.ResponseText

Response = Replace(Response,"\r","")
Response = Replace(Response,"\" & Chr(34),"`")
Response = Replace(Response,Chr(34) & "," & Chr(34),Chr(34))
Response = Replace(Response,Chr(34),"|")
Response = Replace(Response,"`",Chr(34))

ArrResponse = Split(Response,"|")
ArrEnglish = Split(English,"%0D")

Set oFile = oFSO.OpenTextFile(LabelFile,ForWriting,True,Unicode)

j = 0
For i = 1 To UBound(ArrResponse) - 1
  Line = ArrResponse(i)
  PrevLine = ArrResponse(i - 1)
  NextLine = ArrResponse(i + 1)
  EnText = ArrEnglish(j)
  If Line=EnText And NextLine<>EnText Then
    Label = PrevLine
    oFile.Write Label & vbCRLF
    If j=UBound(ArrEnglish) Then Exit For
    j = j + 1
  End If
Next

MsgBox "Labels file created for: " & Lang, vbInformation, Wscript.ScriptName
