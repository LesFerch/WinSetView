# WinSetView Development

If you are an end-user, please ignore this document!

These steps are only for someone who wishes to create the exe from the source code.

WinSetView is a VbsEdit HTML application. Follow the steps below to debug and create WinSetView.exe.

## Exe Creation Steps

1. Install **VbsEdit 25.1** or newer.
2. Install **Visual Studio Community 2022** or newer with the options **Desktop development with C++** and **C++ MFC for latest v1nn build tools (x86 & x64)**.
3. Ensure the files **WinSetView.htm**, **Modal.htm**, **seguiemj.eot**, **UAC.png**, and **WinSetView.ico** are in the WinSetView root folder.
4. Open  **WinSetView.htm** with VbsEdit.
5. Edit code and debug within VbsEdit to make any changes.
6. From the **File** menu, select **Convert into Executable...**.
7. In the dialog, set the options as shown below (increment version number).
8. For the icon, use the **WinSetView.ico** file.

![image](https://github.com/user-attachments/assets/0ed6606a-1f6c-4f06-8613-b1e589a4b596)

9. Click OK to  generate WinSetView.exe.
10. Move WinSetView.exe to the WinSetView root folder.
11. Sign the exe: `signtool sign /n "Open Source Developer, Leslie Ferch" /t http://time.certum.pl/ /fd sha1 /v WinSetView.exe`
