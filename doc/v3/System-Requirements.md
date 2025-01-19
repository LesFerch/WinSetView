## System Requirements

- Windows 7 SP1 or higher
- PowerShell 2 or higher
- MSHTML 8 or higher
- .Net 4.8
- JScript

.Net 4.8, dates back to 2019 and is a common requirement, so it's probably already installed.

JScript is built in and Windows does not provide a user option to disable or remove it, so it should be present. Previous versions of WinSetView used VBScript. As of version 3.1.0, all VBScript code has been replaced with JScript code in WinSetView in anticipation of VBScript becoming an optional install starting in 2027.

WinSetView does NOT use MSHTA.exe or WSH (WScript.exe).

If you're using Windows 10 or higher, please ignore the rest of this document.

### Windows 7 and 8 Notes

If you do a fresh install of Windows 7, it will typically have MSHTML 8 (and Internet Explorer 8). Windows 8 comes with MSHTML 10 and Windows 8.1 should already have MSHTML 11.

WinSetView will run with MSHTML 8, but there will be some minor cosmetic issues, such as dropdown boxes not resizing properly when you change font size (until the program is closed and reopened). Functionally, it should be fine.

If you would like to update to MSHTML 11, you will need to update to Internet Explorer 11. You can then remove IE because WinSetView only needs the updated browser engine and not the browser itself.

If you just built a Windows 7 or 8 machine, first use [Legacy Update](https://legacyupdate.net/) to get crucial updates.

Here are the steps to update **Windows 7 and 8**:

1. If you don't already have .Net 4.8, download and install it from [here](https://support.microsoft.com/en-us/topic/microsoft-net-framework-4-8-offline-installer-for-windows-9d23f658-3b97-68ab-d013-aa3c3e7495e0).


2. Download and install/update Internet Explorer 11 from [here](https://www.microsoft.com/en-us/download/internet-explorer). That will update MSHTML to version 11.


3. **Optional**: Open Control Panel > Programs and Features > Turn Windows features on or off > Uncheck Internet Explorer 11. That will remove the Internet Explorer executable, but will leave MSHTML 11 in place.
