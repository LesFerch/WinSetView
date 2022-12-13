SetLocale(1033)
Const ForReading = 1
Const ForWriting = 2
Const Unicode = -1

Set oFSO = CreateObject("Scripting.FileSystemObject")
Set oHTTP = CreateObject("Microsoft.XMLHTTP")

If Not oFSO.FileExists("..\Language\en-US\Labels.txt") Then
  MsgBox "This script requires en-US Labels.txt to already exist.", vbCritical, Wscript.ScriptName
  Wscript.Quit
End If

RetVal = MsgBox("Click OK to make Labels.txt file for all languages ", vbOKCancel, Wscript.ScriptName)
If RetVal=vbCancel Then Wscript.Quit

ArrLang = Split("cs-CZ,da-DK,de-DE,dir.txt,el-GR,es-ES,et-EE,fi-FI,fr-FR,hr-HR,hu-HU,it-IT,ja-JP,ko-KR,lt-LT,lv-LV,nb-NO,nl-NL,pl-PL,pt-BR,pt-PT,ro-RO,ru-RU,sk-SK,sl-SI,sv-SE,th-TH,tr-TR,uk-UA,vi-VN,zh-CN,zh-TW",",")

For l = 0 to UBound(ArrLang)

  Lang = ArrLang(l)
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

  WScript.Sleep 1000 'Ease up so Google translate doesn't block me
Next

MsgBox "Done", vbInformation, Wscript.ScriptName
