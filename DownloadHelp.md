# How to Download and Run
<!--
To view this document formatted (instead of as raw text) just click the Help button in WinSetView.hta.
You can also manually navigate your browser to: https://lesferch.github.io/WinSetView.
-->
Follow the steps below to download, extract, and run WinSetView for the first time.

**Note**: If you got WinSetView from [here](https://lesferch.github.io/WinSetView), it's 100% clean, but you may find that some security software will falsely detect it as potentially unwanted or potentially malicious. That's the nature of such software. It will err on the side of caution. If you encounter that situation, you will need to disable or, at least, dial-back the protection settings of your security software. For example, in Bitdefender, you must temporarily turn off **Advanced Threat Defense** to allow WinSetView to launch the its PowerShell script that applies the folder view settings.

**Note**: Windows Defender should not have any issue with WinSetView, but if you've installed Windows from a recovery partition or older ISO file, you may be running Defender with old definitions that falsely detect it as malware. Please ensure that Windows Defender is fully up to date before attempting to dowload or run WinSetView. If you still have an issue with Windows Defender, please open an issue on the WinSetView [issue page](https://github.com/LesFerch/WinSetView/issues).

## Step 1: Click the WinSetView Download Link

[![image](https://user-images.githubusercontent.com/79026235/152910441-59ba653c-5607-4f59-90c0-bc2851bf2688.png)Download the zip file](https://github.com/LesFerch/WinSetView/archive/refs/heads/main.zip)

## Step 2: Open the Folder Containing the Zip File

This can be done directly from the browser, but will look different for every browser. For example...

**Edge**:\
![image](https://user-images.githubusercontent.com/79026235/153105994-4ae67c3f-bd51-48b7-88c3-f8adf81591c8.png)

**Chrome**:\
![image](https://user-images.githubusercontent.com/79026235/153104134-7494fbbb-c169-493d-b811-1cc5d7da5c00.png)

Alternatively, you can open the folder (usually the **Downloads** folder) using Windows File Explorer.

## Step 3: Extract the Entire Zip File

Right-click the downloaded zip file and select **Extract All...**.

**Note**: If you have a third-party unzip tool installed (such as 7-Zip, Bandizip, WinZip, WinRAR, etc.) then you may see different unzip options when you right-click the zip file. Any option that unzips the file will do. If there is something like a "smart unzip" option, that is usually the best choice, and won't require editing the unzip path, as indicated below.

![02](https://user-images.githubusercontent.com/79026235/153107248-5f0ccc0b-ca21-4102-8492-1df02129f978.png)

Edit the displayed folder path to remove the **WinSetView-main** part and then click **Extract**.

![image](https://user-images.githubusercontent.com/79026235/153104464-b64a9efb-181a-468a-a457-63455f490f32.png)

Once the extraction is complete, you should have a **WinSetView-main** folder. You can now delete the **WinSetView-main.zip** file.

**Note**: If you leave the path as is, you will end up with nested **WinSetView-main** folders, but it will still work just fine.

**Note**: If you downloaded using the GitHub release link, **main** will be replaced with a version number, but everything else is the same.

## Step 3: Open the App

Open the extracted folder and you should see **WinSetView.exe**. If you do not see the **exe** file extension, check **File name extensions** in the Windows File Explorer **View** menu.

![image](https://user-images.githubusercontent.com/79026235/211452575-65e95101-6251-4260-9843-20ca02426cf7.png)

To avoid annoying "unrecognized app" notifications, right-click **WinSetView.exe** and select **Properties**:

![image](https://user-images.githubusercontent.com/79026235/211460037-48b4a394-b38e-424b-b74c-e216d498d89e.png)

Then check **Unblock**, and click **OK**.

Double-click **WinSetView.exe** to open the app.

WinSetView.exe requires .Net 4.x which is normally already installed. If it's missing, you will see an error similar to this:

![image](https://user-images.githubusercontent.com/79026235/211448690-82bf997a-e931-47b1-a9ac-b77768de5ff8.png)

You can correct the above error by downloading and running the .Net 4.8 installer by clicking this Microsoft [link](https://go.microsoft.com/fwlink/?linkid=2088631).

WinSetView should now load. However, if you did not unblock the file, you will probably see this message:

![image](https://user-images.githubusercontent.com/79026235/211442632-d4362bed-3600-4c32-b2c1-417b320684b7.png)

Click the **More info** link and you should see:

![image](https://user-images.githubusercontent.com/79026235/211442671-34f91125-e915-4c5e-a61e-a30bb556d393.png)

Click **Run anyway** to run the app.

**Note**: On Windows 11, the Publisher will be displayed as **US, New York, Leslie S Ferch, Leslie S Ferch**.

**Note**: Even though WinSetView.exe is code-signed, with a certificate issued by Sectigo, the SmartScreen block will still come up because non-incorporated individual developers cannot purchase (and typically cannot afford) an extended verification (EV) certificate required to get full trust. The fact that WinSetView is provided as an open-source app via GitHub, with my personal contact information available for all to see, is much more reassurance of safety than any certificate provides. The bad actors out there can find ways to code-sign their malware. Knowing where you got the app is much more important. Although there are many trustworthy download sites, the best practice is to download from the author's web page. If you got this app from my [web page](https://lesferch.github.io/WinSetView/), that's your best protection.

**Note**: WinSetView.exe is just a launcher that runs WinSetView.hta. If you prefer, you can directly run the HTA file, as long as HTA files are correctly associated on your machine. The association does not need to be correct to launch the app using the EXE.

**Note**: On some computers, MSHTA.exe (the Microsoft program that loads HTA files) may be blocked or redirected to another executable causing an error message to be displayed or causing nothing to run. The block may be caused by third party antivirus/antimalware software or may be caused by a group policy setting. If you're using a company owned computer then I wouldn't recommend tampering with such settings, but if it's your own machine, you can temporarily disable those restrictions. A version of WinSetView, that does not depend on MSHTA.exe, is currently in the works. In the meantime, if you can't run WinSetView, feel free to open an issue on the [issues page](https://github.com/LesFerch/WinSetView/issues) and I'll do my best to help provide a workaround.

If you are comfortable at the command line, a good option is to run WinSetView on another computer to create an INI file with your preferred view settings. Then run `.\WinSetView.ps1 .\AppData\Win10.ini` (or whatever the INI file name is) on the target computer. You may need to first allow PowerShell scripts to run by entering a command such as: `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser`

To use WinSetView, please follow the steps in the quick start guide:

![image](https://user-images.githubusercontent.com/79026235/152913587-d294de81-c8ca-428d-b351-09a564854eff.png)
[See the quick start guide](./README.md)
