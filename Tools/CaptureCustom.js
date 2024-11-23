// This script captures keys that may contain settings beyond what can be set in WinSetView.
// The reg file created by this script can be renamed to WinSetViewCustom.reg and placed in the
// WinSetView AppData folder to provide additional custom settings.
// If you don't know what you're doing, please do not use this extra level of customization!

ForReading = 1;
ForWriting = 2;
Unicode = -1;
Ansi = 0;
vbCancel = 2;
vbOKCancel = 1;
vbInformation = 64;
Z = "\r\n"; ZZ = Z + Z;

oWSH = WScript.CreateObject("Wscript.Shell");
oFSO = WScript.CreateObject("Scripting.FileSystemObject");

function MsgBox(prompt, buttons, title) {
  oWSH.Popup(prompt, 0, title, buttons);
}

Temp = oWSH.ExpandEnvironmentStrings("%Temp%");
TempFile = Temp + "\\WinSetView.tmp";
CaptureFile = ".\\WinSetViewCustom.reg";

CPan = "\"" + "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ControlPanel" + "\"";
BagM = "\"" + "HKCU\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\BagMRU" + "\"";
Bags = "\"" + "HKCU\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\Bags" + "\"";

RetVal = MsgBox("This is an optional configuration tool for power users." + ZZ + "Click OK to capture keys ControlPanel, BagMRU, and Bags to: " + CaptureFile, vbOKCancel, WScript.ScriptName);
if (RetVal == vbCancel) WScript.Quit();

oOutput = oFSO.OpenTextFile(CaptureFile, ForWriting, true, Ansi);

oOutput.Write("Windows Registry Editor Version 5.00" + ZZ);
oOutput.Write("; Place this file in your WinSetView AppData folder to have it applied by WinSetView." + Z);

oWSH.Run("Reg Export " + CPan + " " + TempFile + " /y", 0, true);

oInput = oFSO.OpenTextFile(TempFile, ForReading, false, Unicode);
while (!oInput.AtEndOfStream) {
  Line = oInput.ReadLine();
  if (Line != "Windows Registry Editor Version 5.00") oOutput.Write(Line + Z);
}
oInput.Close();

oWSH.Run("Reg Export " + BagM + " " + TempFile + " /y", 0, true);

oInput = oFSO.OpenTextFile(TempFile, ForReading, false, Unicode);
while (!oInput.AtEndOfStream) {
  Line = oInput.ReadLine();
  if (Line != "Windows Registry Editor Version 5.00") oOutput.Write(Line + Z);
}
oInput.Close();

oWSH.Run("Reg Export " + Bags + " " + TempFile + " /y", 0, true);

oInput = oFSO.OpenTextFile(TempFile, ForReading, false, Unicode);
while (!oInput.AtEndOfStream) {
  Line = oInput.ReadLine();
  if (Line.indexOf("\\AllFolders") != -1) break;
  if (Line != "Windows Registry Editor Version 5.00") oOutput.Write(Line + Z);
}
oInput.Close();

oOutput.Close();

MsgBox("Done. See file: " + CaptureFile, vbInformation, WScript.ScriptName);
