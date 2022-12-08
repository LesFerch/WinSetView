SetLocale(1033)
Const ForReading = 1
Const ForWriting = 2
Const Unicode = -1

Set oOrder = CreateObject("Scripting.Dictionary")
oOrder.Add "Global","Global"
oOrder.Add "Downloads","Downloads"
oOrder.Add "Generic","General Items"
oOrder.Add "Generic.Library","General Items Library"
oOrder.Add "StorageProviderGeneric","General Items OneDrive"
oOrder.Add "Generic.SearchResults","General Items Search Results"
oOrder.Add "Documents","Documents"
oOrder.Add "Documents.Library","Documents Library"
oOrder.Add "StorageProviderDocuments","Documents OneDrive"
oOrder.Add "Documents.SearchResults","Documents Search Results"
oOrder.Add "Music","Music"
oOrder.Add "Music.Library","Music Library"
oOrder.Add "StorageProviderMusic","Music OneDrive"
oOrder.Add "Music.SearchResults","Music Search Results"
oOrder.Add "Pictures","Pictures"
oOrder.Add "Pictures.Library","Pictures Library"
oOrder.Add "StorageProviderPictures","Pictures OneDrive"
oOrder.Add "Pictures.SearchResults","Pictures Search Results"
oOrder.Add "Videos","Videos"
oOrder.Add "Videos.Library","Videos Library"
oOrder.Add "StorageProviderVideos","Videos OneDrive"
oOrder.Add "Videos.SearchResults","Videos Search Results"
oOrder.Add "Contacts","Contacts"
oOrder.Add "Contacts.Library","Contacts Library"
oOrder.Add "Contacts.SearchResults","Contacts Search Results"
oOrder.Add "HomeFolder","Quick access"
oOrder.Add "UserFiles","User Files"
oOrder.Add "UserFiles.SearchResults","User Files Search Results"
oOrder.Add "Searches","Searches"
oOrder.Add "AccountPictures","Account Pictures"
oOrder.Add "UsersLibraries","Users Libraries"
oOrder.Add "UsersLibraries.SearchResults","Users Libraries Search Results"
oOrder.Add "OtherUsers","Other Users"
oOrder.Add "OtherUsers.SearchResults","Other Users Search Results"
oOrder.Add "PublishedItems","Published Items"
oOrder.Add "PublishedItems.SearchResults","Published Items Search Results"
oOrder.Add "OpenSearch","Open Search"
oOrder.Add "SearchConnector","Search Connector"
oOrder.Add "FileItemAPIs","File Item APIs"

Set oWSH = CreateObject("Wscript.Shell")
Set oFSO = CreateObject("Scripting.FileSystemObject")
Set oHTTP = CreateObject("Microsoft.XMLHTTP")

Temp  = oWSH.ExpandEnvironmentStrings("%Temp%")
TempFile = Temp & "\WinSetView.tmp"
LMFT = "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes"

Lang = oWSH.RegRead("HKCU\Control Panel\Desktop\PreferredUILanguages")(0)
Lang = InputBox("Language:", Wscript.ScriptName, Lang)
If Lang="" Then Wscript.Quit

RetVal = MsgBox("Click OK to make FolderTypes file for: " & Lang, vbOKCancel, Wscript.ScriptName)
If RetVal=vbCancel Then Wscript.Quit

LangPath = "..\Language\" & Lang
If Not oFSO.FolderExists(LangPath) Then oFSO.CreateFolder(LangPath)
FTFile = LangPath & "\FolderTypes.txt"

Set oTrans = CreateObject("Scripting.Dictionary")

Translate = True
If LCase(Left(Lang,2))="en" Then Translate = False

If Translate Then

  For Each oItem In oOrder.Items
    English = English & oItem & "%0D"
    oTrans.Add oItem,""
  Next

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

  j = 0
  For i = 1 To UBound(ArrResponse) - 1
    Line = ArrResponse(i)
    PrevLine = ArrResponse(i - 1)
    NextLine = ArrResponse(i + 1)
    FTNameEn = ArrEnglish(j)
    If Line=FTNameEn And NextLine<>FTNameEn Then
      FTNameLang = PrevLine
      If oTrans.Exists(FTNameEn) Then
        oTrans.Item(FTNameEn) = FTNameLang
      End If
      If j=UBound(ArrEnglish) Then Exit For
      j = j + 1
    End If
  Next

End If

oWSH.Run "Reg Export " & LMFT & " " & TempFile & " /y",0,True

Set oFile = oFSO.OpenTextFile(TempFile,ForReading,,Unicode)
Set oFolderTypes = CreateObject("Scripting.Dictionary")
oFolderTypes.Add "Global","{00000000-0000-0000-0000-000000000000}"
i = 0
Do Until oFile.AtEndOfStream
  Line = oFile.ReadLine
  If InStr(Line,"HKEY_LOCAL_MACHINE") Then GUID = Line
  If InStr(Line,"CanonicalName") Then
    GUID = Replace(GUID,"[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\","")
    GUID = Replace(GUID,"]","")
    Line = Replace(Line,Chr(34),"")
    FT = Replace(Line,"CanonicalName=","")
    If oFolderTypes.Exists(FT) Then FT = FT & i
    oFolderTypes.Add FT,GUID
    i = i + 1
  End If
Loop
oFile.Close

Set oFile = oFSO.OpenTextFile(FTFile,ForWriting,True,Unicode)
For Each oItem In oOrder.Keys
  FT = oItem
  If oFolderTypes.Exists(FT) Then
    GUID = oFolderTypes(oItem)
    FTName = oOrder.Item(FT)
    If Translate Then FTName = oTrans.Item(oOrder.Item(FT))
    oFile.Write GUID & ";" & FT & ";" & String(30 - Len(FT)," ") & FTName & vbCRLF
  End If
Next
oFile.Close

MsgBox "FolderTypes file created for: " & Lang, vbInformation, Wscript.ScriptName
