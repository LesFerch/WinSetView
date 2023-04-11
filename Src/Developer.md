# WinSetView Development

Starting with version 2.70, WinSetView is a VbsEdit HTML application. Follow the steps below to debug and create WinSetView.exe.

If you are an end-user, please ignore this document!

## Exe Creation Steps

1. Install **VbsEdit 23.3.28.5** or newer.
2. Move the files **WinSetView.htm**, **Modal.htm**, and **seguiemj.eot** from the **Src** folder to the WinSetView root folder.
3. Open  **WinSetView.htm** with VbsEdit.
4. Edit code and debug within VbsEdit to make any changes.
4. From the **File** menu, select **Convert into Executable...**.
5. In the dialog, set the options as shown (increment version number):

![image](https://user-images.githubusercontent.com/79026235/229970503-3166129f-3be3-4809-8890-d1712ac9b5d5.png)

6. Click OK to  generate WinSetView.exe.
7. Move WinSetView.exe to the WinSetView root folder.
8. Exit VbsEdit and move the source files back to the **Src** subfolder.
