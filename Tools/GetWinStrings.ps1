$Source = @'
using System;
using System.Runtime.InteropServices;
using System.Text;
public class ExtractData {
  [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Ansi)]
  private static extern IntPtr LoadLibrary([MarshalAs(UnmanagedType.LPStr)]string lpFile);
  [DllImport("user32.dll", CharSet = CharSet.Auto)]
  private static extern int LoadString(IntPtr hInstance, int ID, StringBuilder lpBuffer, int nBufferMax);
  [DllImport("kernel32.dll", SetLastError = true)]
  [return: MarshalAs(UnmanagedType.Bool)]
  private static extern bool FreeLibrary(IntPtr hModule);
  public string ExtractStringFromDLL(string file, int number) {
    IntPtr lib = LoadLibrary(file);
    StringBuilder result = new StringBuilder(2048);
    LoadString(lib, number, result, result.Capacity);
    FreeLibrary(lib);
    return result.ToString();
  }
}
'@

Add-Type -TypeDefinition $Source
$ed = New-Object ExtractData
$CRLF = "`r`n"

Get-ChildItem -Path '..\Language' -Directory | ForEach {

  $Lang = $_.Name
  $d1 = ''
  $d2 = ''

  $File = 'C:\Windows\System32\' + $Lang + '\ExplorerFrame.dll.mui'

  If (Test-Path -Path $File) {
    $d1 = $d1 + $ed.ExtractStringFromDLL($File,49933) + $CRLF # View
    $d1 = $d1 + $ed.ExtractStringFromDLL($File,41733) + $CRLF # Details
    $d1 = $d1 + $ed.ExtractStringFromDLL($File,41732) + $CRLF # List
    $d1 = $d1 + $ed.ExtractStringFromDLL($File,41734) + $CRLF # Tiles
    $d1 = $d1 + $ed.ExtractStringFromDLL($File,41735) + $CRLF # Content
    $d1 = $d1 + $ed.ExtractStringFromDLL($File,41731) + $CRLF # Small icons
    $d1 = $d1 + $ed.ExtractStringFromDLL($File,41730) + $CRLF # Medium icons
    $d1 = $d1 + $ed.ExtractStringFromDLL($File,41729) + $CRLF # Large icons
    $d1 = $d1 + $ed.ExtractStringFromDLL($File,41728) + $CRLF # Extra large icons

    $File = 'C:\Windows\System32\' + $Lang + '\Shell32.dll.mui'

    If (Test-Path -Path $File) {
      $d1 = $d1 + $ed.ExtractStringFromDLL($File,4256)          # (None)

      $d2 = $d2 + $ed.ExtractStringFromDLL($File,21798) + $CRLF # Downloads
      $d2 = $d2 + $ed.ExtractStringFromDLL($File,29990) + $CRLF # General items
      $d2 = $d2 + $ed.ExtractStringFromDLL($File,21770) + $CRLF # Documents
      $d2 = $d2 + $ed.ExtractStringFromDLL($File,17450) + $CRLF # Music
      $d2 = $d2 + $ed.ExtractStringFromDLL($File,17451) + $CRLF # Pictures
      $d2 = $d2 + $ed.ExtractStringFromDLL($File,17452) + $CRLF # Videos
      $d2 = $d2 + $ed.ExtractStringFromDLL($File,29997) + $CRLF # Contacts
      $d2 = $d2 + $ed.ExtractStringFromDLL($File,51378) + $CRLF # Quick access
      $d2 = $d2 + $ed.ExtractStringFromDLL($File,9031)  + $CRLF # Searches
      $d2 = $d2 + $ed.ExtractStringFromDLL($File,9216)  + $CRLF # This PC
      $d2 = $d2 + $ed.ExtractStringFromDLL($File,9217)          # Network
    }
    If ($d1 -ne '') {
      Out-File -InputObject $d1 -encoding Unicode -filepath "..\Language\$Lang\ViewList.txt"
    }
    If ($d2 -ne '') {
      Out-File -InputObject $d2 -encoding Unicode -filepath "..\Language\$Lang\Strings.txt"
    }
  }
}