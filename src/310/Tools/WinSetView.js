INIFile = "";
// INIFile = ".\\Win10.ini";
if (WScript.Arguments.length > 0) INIFile = WScript.Arguments(0);

oWSH = WScript.CreateObject("Wscript.Shell");
oFSO = WScript.CreateObject("Scripting.FileSystemObject");

MyPath = oFSO.GetParentFolderName(WScript.ScriptFullName)
oWSH.CurrentDirectory = MyPath;
Z = "\r\n"; ZZ = Z + Z;

function MsgBox(prompt, buttons, title) {
  var result = oWSH.Popup(prompt, 0, title, buttons);
  return(result);
}

if (!oFSO.FileExists(INIFile)) {
  Msg = "Run WinSetView.exe to create or update an INI file." + ZZ;
  Msg += "Then drop the INI file on this script to run ";
  Msg += "WinSetView.ps1 with the saved settings." + ZZ;
  Msg += "This script can be relocated to the WinSetView AppData folder.";
  MsgBox(Msg, 0 + 64, "GUI-less Execution Instructions:");
} else {
  CmdLine = "Powershell.exe -ExecutionPolicy Bypass ..\\WinSetView.ps1 " + INIFile;
  oWSH.Run(CmdLine, 1, false);
}
