## System Requirements

- Windows 7 or higher
- PowerShell 2 or higher
- MSHTML 11
- .Net 4.8

MSHTML 11 dates back to 2013, so it's expected to be installed on all computers. .Net 4.8, dates back to 2019 and is a common requirement, so it's probably already installed.

If you're using Windows 10 or higher, please ignore the rest of this document.

### Windows 7 and 8 Notes

If you do a fresh install of Windows 7, it will typically have MSHTML 8 (and Internet Explorer 8). Windows 8 comes with MSHTML 10 and Windows 8.1 should already have MSHTML 11.

To get MSHTML 11, you will need to update to Internet Explorer 11. You can then remove IE because WinSetView only needs the updated browser engine and not the browser itself.

If you just built a Windows 7 or 8 machine, first use [Legacy Update](https://legacyupdate.net/) to get crucial updates.

Here are the steps to update **Windows 7 and 8**:

1. If you don't already have .Net 4.8, download and install it from [here](https://support.microsoft.com/en-us/topic/microsoft-net-framework-4-8-offline-installer-for-windows-9d23f658-3b97-68ab-d013-aa3c3e7495e0).


2. Download and install/update Internet Explorer 11 from [here](https://www.microsoft.com/en-us/download/internet-explorer). That will update MSHTML to version 11.


3. **Optional**: Open Control Panel > Programs and Features > Turn Windows features on or off > Uncheck Internet Explorer 11. That will remove the Internet Explorer executable, but will leave MSHTML 11 in place.
