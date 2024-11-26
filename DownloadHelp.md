# How to Download and Run
<!--
To view this document formatted (instead of as raw text) just click the Help button in WinSetView.
You can also manually navigate your browser to: https://lesferch.github.io/WinSetView.
-->
Follow the steps below to download, extract, and run WinSetView for the first time.

**Note**: If you got WinSetView from [here](https://lesferch.github.io/WinSetView), it's 100% clean, but you may find that some security software will falsely detect it as potentially unwanted or potentially malicious. That's the nature of such software. It will err on the side of caution. If you encounter that situation, you will need to disable or, at least, dial-back the protection settings of your security software. For example, in **Bitdefender**, you must temporarily turn off **Advanced Threat Defense** to allow WinSetView to launch the PowerShell script that applies the folder view settings.

**Note**: Windows Defender should not have any issue with WinSetView, but if you've installed Windows from a recovery partition or older ISO file, you may be running Defender with old definitions that falsely detect it as malware. Please ensure that Windows Defender is fully up to date before attempting to download or run WinSetView. If you still have an issue with Windows Defender, please try clearing the Windows Defender history using [this tool](https://lesferch.github.io/ClearDefenderHistory/). If problems persist, please open an issue on the [issues page](https://github.com/LesFerch/WinSetView/issues).

## Step 1: Click the WinSetView Download Link

[![image](https://github.com/LesFerch/WinSetView/assets/79026235/0188480f-ca53-45d5-b9ff-daafff32869e)Download the zip file](https://github.com/LesFerch/WinSetView/releases/download/2.99.1/WinSetView.zip)

## Step 2: Open the Folder Containing the Zip File

This can be done directly from the browser, but will look different for every browser. For example...

**Edge**:\
![image](https://github.com/user-attachments/assets/88d74121-81e4-439b-b989-7d49a4a7ce67)

**Chrome**:\
![image](https://github.com/user-attachments/assets/f17d7b14-afce-4074-a9c6-ced059d7e68e)


Alternatively, you can open the folder (usually the **Downloads** folder) using Windows File Explorer.

## Step 3: Extract the Entire Zip File

Right-click the downloaded zip file and select **Extract All...**

**Note**: If you have a third-party unzip tool installed (such as 7-Zip, Bandizip, WinZip, WinRAR, etc.) then you may see different unzip options when you right-click the zip file. Any option that unzips the file will do. Something like "smart unzip" is usually the best choice.

![image](https://github.com/user-attachments/assets/d2f87465-745a-4f69-a58e-1fdbb3f8aada)

Then just click **Extract**:

![image](https://github.com/user-attachments/assets/5d3a4773-bfa6-4366-95fa-9a0581dd9858)

Once the extraction is complete, you should have a **WinSetView** folder. You can now delete the **WinSetView.zip** file.

## Step 3: Open the App

Open the extracted folder and you should see **WinSetView.exe**. If you do not see the **exe** file extension, please enable the option to show file extensions...

Windows 10:

![image](https://github.com/user-attachments/assets/9d7674b1-8335-4eb4-8fe8-c40b50f1a815)

Windows 11:

![image](https://github.com/user-attachments/assets/06c6cffb-9b08-4e75-83da-92fc26e5a1dd)




To avoid annoying "unrecognized app" notifications, right-click **WinSetView.exe** and select **Properties**:

![image](https://github.com/LesFerch/WinSetView/assets/79026235/f1e8ee66-ffe5-4f07-9fa1-e6f41f51f1cf)

Then check **Unblock**, and click **OK**.

Double-click **WinSetView.exe** to open the app.

If you did not unblock the file, you will probably see this message:

![image](https://github.com/LesFerch/WinSetView/assets/79026235/6176a166-1c62-4c92-8e32-acd968023bc5)

Click the **More info** link and you should see:

![image](https://github.com/LesFerch/WinSetView/assets/79026235/750966d4-4daa-400b-9da2-0a329cddb3da)

Click **Run anyway** to run the app.

**Note**: On Windows 11, the Publisher will be displayed as **US, New York, Pleasantville, Open Source Developer, Open Source Developer, Leslie Ferch**.

**Note**: Even though WinSetView.exe is code-signed, with a certificate issued by Certum, the SmartScreen block will still come up because non-incorporated individual developers cannot purchase (and typically cannot afford) an extended verification (EV) certificate required to get full trust. The fact that WinSetView is provided as an open-source app via GitHub, with my personal contact information available for all to see, is much more reassurance of safety than any certificate provides. The bad actors out there can find ways to code-sign their malware. Knowing where you got the app is much more important. Although there are many trustworthy download sites, the best practice is to download from the author's web page. If you got this app from my [web page](https://lesferch.github.io/WinSetView/), that's your best protection.

## Possible Launch Error

The following error will be displayed if VBScript has been disabled or uninstalled:

![image](https://github.com/LesFerch/WinSetView/assets/79026235/a11c3e97-670f-4f09-8b4a-7b656cb3849b)

If the above error is displayed and you're running **Windows 11**, please check **Settings**, **System**, **Optional features**, **View features**, and then scroll down and see if there is a **VBScript** item. If so, check it and click **Next** and then **Install**.

If your computer is managed by an IT department, it's possible that VBScript has been intentionally disabled. Or you may have intentionally disabled VBScript yourself. In either case, you can use the new JScript version of WinSetView instead.

The next release of WinSetView will use JScript code instead of VBScript code. That new version is available now as a beta. Please see the [Releases](https://github.com/LesFerch/WinSetView/releases) page to download it.



## How to Use

To use WinSetView, please follow the steps in the quick start guide:

![image](https://github.com/LesFerch/WinSetView/assets/79026235/41afd0e5-72c9-40e3-a1a0-fbb4dc591de9)
[See the quick start guide](./README.md)
