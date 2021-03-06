SetLocale(1033)
Const ForReading = 1
Const ForWriting = 2
Const Unicode = -1

Set oTopItems = CreateObject("Scripting.Dictionary")
oTopItems.Add "ItemNameDisplay",""
oTopItems.Add "ItemFolderPathDisplay",""
oTopItems.Add "ItemFolderPathDisplayNarrow",""
oTopItems.Add "ItemPathDisplay",""
oTopItems.Add "ItemFolderNameDisplay",""
oTopItems.Add "Search.Rank",""
oTopItems.Add "DateModified",""
oTopItems.Add "DateCreated",""
oTopItems.Add "DateAccessed",""
oTopItems.Add "Size",""
oTopItems.Add "ItemTypeText",""
oTopItems.Add "ItemType",""
oTopItems.Add "PerceivedType",""
oTopItems.Add "ContentType",""
oTopItems.Add "Kind",""
oTopItems.Add "FileExtension",""
oTopItems.Add "FileOwner",""
oTopItems.Add "FileAttributes",""
oTopItems.Add "FileVersion",""
oTopItems.Add "Software.ProductVersion",""
oTopItems.Add "FileDescription",""
oTopItems.Add "Author",""
oTopItems.Add "Keywords",""
oTopItems.Add "Rating",""
oTopItems.Add "ItemDate",""
oTopItems.Add "Photo.DateTaken",""
oTopItems.Add "Image.Dimensions",""
oTopItems.Add "Media.DateEncoded",""
oTopItems.Add "Title",""
oTopItems.Add "TitleSortOverride",""
oTopItems.Add "Video.EncodingBitrate",""
oTopItems.Add "Audio.EncodingBitrate",""
oTopItems.Add "Media.Duration",""
oTopItems.Add "DRM.IsProtected",""
oTopItems.Add "Music.Artist",""
oTopItems.Add "Music.ArtistSortOverride",""
oTopItems.Add "Music.AlbumArtist",""
oTopItems.Add "Music.AlbumArtistSortOverride",""
oTopItems.Add "Music.AlbumTitle",""
oTopItems.Add "Music.AlbumTitleSortOverride",""
oTopItems.Add "Music.Composer",""
oTopItems.Add "Music.ComposerSortOverride",""
oTopItems.Add "Music.Genre",""
oTopItems.Add "Media.Year",""
oTopItems.Add "Music.TrackNumber",""

Dim ArrColumns(400), ArrLine

Set oWSH    = CreateObject("Wscript.Shell")
Set oShApp  = CreateObject("Shell.Application")
Set oFSO    = CreateObject("Scripting.FileSystemObject")
Set oStream = CreateObject("ADODB.Stream")
Set oFolder = oShApp.NameSpace("C:\")
oStream.CharSet = "UTF-8"

WinVer = oWSH.RegRead("HKLM\Software\Microsoft\Windows NT\CurrentVersion\ProductName")
WinVer = Trim(Replace(Mid(WinVer,9,2),"."," "))

Lang = oWSH.RegRead("HKCU\Control Panel\Desktop\PreferredUILanguages")(0)

RetVal = MsgBox("Click OK to make column heading language file for: " & Lang, vbOKCancel, Wscript.ScriptName)
If RetVal=vbCancel Then Wscript.Quit

LangPath = "..\Language\" & Lang
If Not oFSO.FolderExists(LangPath) Then oFSO.CreateFolder(LangPath)
PropFile = ".\Properties.csv"
ColumnListFile = LangPath & "\Columns-Win" & WinVer & ".txt"
PSVexe = ".\PropertySystemView.exe"

If Not oFSO.FileExists(PSVexe) Then MsgBox PSVexe, vbCritical ,"File Needed:": Wscript.Quit

oWSH.Run PSVexe & " /AllProperties /scomma " & PropFile,1,True

oStream.Open
oStream.LoadFromFile PropFile
PropData = oStream.ReadText
oStream.Close

ArrPropData = Split(PropData,vbCRLF)
ArrPropLast = UBound(ArrPropData)
j = 0
x = 0

Sub FindMatch
  For j = 0 To ArrPropLast
    ArrPropData(j) = Replace(ArrPropData(j),", ","~~~")
    ArrPropData(j) = Replace(ArrPropData(j),Chr(34),"")
    ArrLine = Split(ArrPropData(j),",")
    If UBound(ArrLine)>4 Then
      If Mid(ArrLine(0),1,7)="System." Then
        ArrLine(1) = Replace(ArrLine(1),"~~~",", ")
        If LocalName=ArrLine(1) And ArrLine(5)="Yes" Then
          AddLine
          Found = Found & LocalName & vbCRLF
          Exit For
        End If
      End If
    End If
  Next
End Sub

Sub AddLine
  Prop = Mid(ArrLine(0),8)
  Pair = LocalName & ";" & Prop
  If oTopItems.Exists(Prop) Then
    oTopItems.Item(Prop) = LocalName
  Else
    ArrColumns(x) = Pair
    x = x + 1
  End If
  ArrPropData(j) = ""
End Sub

x = 0
LocalName = ""

For i = 0 To 400
  LocalName = oFolder.GetDetailsOf(Null,i)
  If LocalName<>"" Then
    All = All & LocalName & vbCRLF
    FindMatch
  End If
Next

ArrTopKeys = oTopItems.Keys
ArrTopItems = oTopItems.Items

Last = UBound(ArrColumns)
x = Last - 1
For i = x To 0 Step -1
  For j= 0 To i
    If ArrColumns(j+1)<>"" Then
      Item = ArrColumns(j)
      NextItem = ArrColumns(j+1)
      If Item>NextItem Then
        temp=ArrColumns(j+1)
        ArrColumns(j+1)=ArrColumns(j)
        ArrColumns(j)=temp
      End If
    End If
  Next
Next

Last = UBound(ArrTopKeys)
Set oFile = oFSO.OpenTextFile(ColumnListFile,ForWriting,True,Unicode)
For i = 0 To Last
  If ArrTopItems(i)<>"" Then oFile.Write ArrTopItems(i) & ";" & ArrTopKeys(i) & VBCRLF
Next
For i = 0 To 400
  If ArrColumns(i)<>"" Then oFile.Write ArrColumns(i) & VBCRLF
Next
oFile.Close

MsgBox "Column heading language file created for: " & Lang, vbInformation, Wscript.ScriptName
