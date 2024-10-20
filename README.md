# WinSetView
<!--
To view this document formatted (instead of as raw text) just click the Help button in WinSetView.
You can also manually navigate your browser to: https://lesferch.github.io/WinSetView.
-->

This is the quick start guide. For more details, please see the [complete user manual](./Manual.md).

[![image](https://github.com/LesFerch/WinSetView/assets/79026235/0188480f-ca53-45d5-b9ff-daafff32869e)Download the zip file](https://github.com/LesFerch/WinSetView/releases/download/2.99/WinSetView.zip)

[![image](https://github.com/user-attachments/assets/75e62417-c8ee-43b1-a8a8-a217ce130c91)Download the installer](https://github.com/LesFerch/WinSetView/releases/download/2.99/WinSetView-Setup.exe)


### Globally Set Explorer Folder Views

Compatible with Windows 7, 8, 10, and 11.

[Version 2.99](./VersionHistory.md)

## Summary

WinSetView provides an easy way to set Windows File Explorer default folder views. For example, if you want Details view, with a particular selection of column headings enabled across all folders, then WinSetView will do that for you.

For more details, please see the [extended summary](./README-more.md).

## How to Download and Run

### Portable Install Using Zip File (Recommended)

WinSetView is a portable app, allowing it to be run from anywhere, such as flash drive, for easy configuration of new users/computers. The settings remain with the app itself, as long as it's placed in a location where you have full write access. If it's placed in a restricted folder, such as `C:\Program Files (x86)`, the settings will automatically get written to your `%AppData%` folder, which is fine, but then it's not as portable.

1. Download the zip file using the link above.
2. Extract the entire zip file.
3. Right-click **WinSetView.exe**, select **Properties**, check **Unblock**, and click **OK**.
4. Run **WinSetView.exe**.
5. If you skipped step 3, then, in the SmartScreen window, click **More info** and then **Run anyway**.

**Note**: If your security software blocks the download or the app does not launch or you wish to read more about SmartScreen prompts, please see: [Download Help Guide](./DownloadHelp.md)

### Updating a Portable Install Using Zip File

1. Follow the steps above to download and unzip the files.
2. Ensure that WinSetView is not currently running.
3. Drag the new files over the old files, allowing them to be replaced. Your settings will not be overwritten because the package does not contain an AppData folder.

### Install Using Setup Program

You may also install WinSetView, so that it appears in your list of installed apps, by using the installer, `WinSetView-Setup.exe`, found on the Releases page (and linked to above).


## How to Use

Simple step by step instructions follow.

**Note**: Nothing in Windows is changed, and no settings are saved, until the **Submit** button is pressed. Feel free to experiment with the WinSetView interface and just **X** out and restart the app to get back to where you started. Display options such as **font**, **font size**, and **theme** are saved to the INI file and are therefore only saved when you click **Submit**. Only the WinSetView window size and position are saved automatically when you click **X** to exit the app.

**Note**: For best results, close all open applications before running WinSetView. Open applications can prevent open/save dialog views from being updated. Apps that minimize to the System Tray when "closed", such as Discord, Steam, and qBittorrent, must be fully closed (e.g. right-click the app's System Tray icon and select `Exit`).

**Note**: Clicking **Submit** will apply the registry setting changes and restart Explorer. Do not click Submit when Explorer is busy copying/moving/deleting files.

For complete details, please see the [manual](./Manual.md).

### Step 1: Select Your Interface Language (Optional)

![image](https://github.com/LesFerch/WinSetView/assets/79026235/ec65e196-e96b-486b-9557-da2f0b29a207)

WinSetView should open in the same language to which you have Windows set. If not, select the correct language from the drop down menu.

### Step 2: Select Your Preferred Default View

![image](https://github.com/LesFerch/WinSetView/assets/79026235/28e14cd3-9a3e-4a01-8a33-d12ee3a2e416)


Select the default view you want applied to most (or all) folders from the drop down menu under the **Global** heading. Most users go with **Details**, but pick what *you* like as your default.

**Note**: If you choose one of the **icons** options, a number will appear next to the drop down menu indicating the icon size. You can manually type in a custom size, such as 72, which would give you icons half-way between medium and large.

### Step 3: Select Your Preferred Default Column Headings (Optional)

![image](https://github.com/LesFerch/WinSetView/assets/79026235/b7766339-7f07-4df4-acb6-88c8c48b2466)

If you are happy with the default Details-view column headings (as shown on screen) then skip this step.

**Note**: Column headings shown in blue are only displayed in *search results* (by default). It is, therefore, recommended to keep the **Folder path** (**File location** in Windows 11) column heading.

![image](https://github.com/LesFerch/WinSetView/assets/79026235/a51ed69a-6373-4a0d-9056-cdce67e104c9)

Otherwise, click the **Columns** button to bring up the column headings selection page.

![image](https://github.com/LesFerch/WinSetView/assets/79026235/4d682192-9447-42aa-8c5b-ecb973669acd)

The column headings selection page allows you to select your desired column headings (and their order), group-by options, sort options, and column widths. The [manual](./Manual.md#columns) provides full details, but you can also hover over or click on elements to see how the interface works.

### Step 4: Set Views for Specific Folder Types (Optional)

![image](https://github.com/LesFerch/WinSetView/assets/79026235/acc2f0d2-63ce-4475-b0a0-325abb7c75e1)

Please note that WinSetView allows you to set the default view for every folder type in Windows, but, by *default*, they will all get the same settings as your **Global** settings, as long as the **Inherit** box is checked.

For any folder type (e.g. **Pictures**) that you wish to have a *different* default view than your global setting, just scroll down to that particular folder type, *uncheck* the **Inherit** box, and repeat steps 2 and 3 for that folder type.

**Note**: You don't have to set the other similar folder types separately. For example, **Pictures Library** will use the same settings as **Pictures** as long as **Inherit** is checked for **Pictures Library**.

**Note**: If you *uncheck* a folder type, then that folder type will display with its Windows default view settings (i.e. the view you would get for a new user account).

### Step 5: Check and Set Your Desired Options

![image](https://github.com/LesFerch/WinSetView/assets/79026235/75ebc931-6d65-41e2-94d3-7624773e6004)

Click The **Options** button.

![image](https://github.com/user-attachments/assets/bacda1ed-300b-44c0-8e47-fa778cebf093)

Review the settings on that page and adjust as desired. See the [manual](./Manual.md#options-menu) for full details. Options with a shield icon require Administrative access and will automatically pop up a UAC prompt if changed.

### Step 6: Apply the Selections to Windows File Explorer

![image](https://github.com/LesFerch/WinSetView/assets/79026235/158ae5ca-3b21-4774-9da9-7529de86f181)

Once you're happy with your selections, make those settings apply to Windows File Explorer by clicking the **Submit** button.

You can always run WinSetView again to change any settings and you can revert back to a previous state using the **Restore** button. You also have the option of setting File Explorer back to Windows defaults by checking **Reset Views to Windows Defaults** and then clicking **Submit**.

**IMPORTANT**: Using **Restore** or **Reset Views to Windows Defaults** only resets folder views. Many of the settings under **Options** are separate from the folder view settings. Please ensure those options are set to what you want.

![image](https://github.com/LesFerch/WinSetView/assets/79026235/50c53943-f673-49da-ad3f-419026deea96)
[See the complete user manual](./Manual.md)
\
\
\
[![image](https://github.com/LesFerch/WinSetView/assets/79026235/63b7acbc-36ef-4578-b96a-d0b7ea0cba3a)](https://github.com/LesFerch/WinSetView)
