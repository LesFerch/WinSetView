# WinSetView

> **NOTE:**
>
> The official WinSetView site is https://lesferch.github.io/WinSetView
>
> Do NOT go to winsetview.com. It's a fake website hosted by a third-party. Do NOT trust them.

<!--
To view this document formatted (instead of as raw text) just click the Help button in WinSetView.
You can also manually navigate your browser to: https://lesferch.github.io/WinSetView.
-->

\
This is the quick start guide. For more details, please see the [complete user manual](./Manual.md).

[![image](https://github.com/LesFerch/WinSetView/assets/79026235/0188480f-ca53-45d5-b9ff-daafff32869e)Download the zip file](https://github.com/LesFerch/WinSetView/releases/download/3.2.1/WinSetView.zip)

[![image](https://github.com/user-attachments/assets/75e62417-c8ee-43b1-a8a8-a217ce130c91)Download the installer](https://github.com/LesFerch/WinSetView/releases/download/3.2.1/WinSetView-Setup.exe)

\
**WinGet**: `winget install winsetview`


### Globally Set Explorer Folder Views

Compatible with Windows 7, 8, 10, and 11.  Click [here](./System-Requirements.md) for system requirements.

[Version 3.2.1](./VersionHistory.md)

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

You may also install WinSetView, so that it appears in your list of installed apps, by using the installer, `WinSetView-Setup.exe`, found on the Releases page (and linked to above). This option requires **administrator** access. The portable install can be done by any user.


## How to Use

Simple step by step instructions follow.

**Caution**: If you are trying to change one thing, and leave everything else as is, please click [here](./WhatToExpect.md) to learn more.

**Note**: Nothing in Windows is changed, and no settings are saved, until the **Submit** button is pressed. Feel free to experiment with the WinSetView interface and just **X** out and restart the app to get back to where you started. Display options such as **font**, **font size**, and **theme** are saved to the INI file and are therefore only saved when you click **Submit**. Only the WinSetView window size and position are saved automatically when you click **X** to exit the app.

**Note**: For best results, close all open applications before running WinSetView. Open applications can prevent open/save dialog views from being updated. Apps that minimize to the System Tray when "closed", such as Discord, Steam, and qBittorrent, must be fully closed (e.g. right-click the app's System Tray icon and select `Exit`).

**Note**: Store apps, such as the Windows 11 Paint and Notepad, are killed automatically by WinSetView to ensure that their file open/save dialog views are refreshed to your new view defaults. Simply closing Store apps is not enough because they often remain running when "closed".

**Note**: Clicking **OK**, in the **Submit** dialog, will apply the registry setting changes and restart Explorer. Do not click OK when Explorer is busy copying/moving/deleting files.

For complete details, please see the [manual](./Manual.md).

**IMPORTANT**: To understand what WinSetView is doing, think in terms of folder TYPES. The items listed in WinSetView, such as "Pictures" represent folder types, not individual folders.

### Step 1: Select Your Interface Language (Optional)

<img width="761" height="195" alt="image" src="https://github.com/user-attachments/assets/ba552c51-ea18-4550-81f1-b54af5ff21a0" />

WinSetView should open in the same language to which you have Windows set. If not, click the gear icon and then select the correct language from the drop down menu.

### Step 2: Select Your Preferred Default View

<img width="761" height="360" alt="image" src="https://github.com/user-attachments/assets/fa8e5185-f875-45fb-b84e-3dc2151682cd" />

Select the default view you want applied to most (or all) folders from the drop down menu under the **Global** heading. Most users go with **Details**, but pick what *you* like as your default.

**Note**: If you choose one of the **icons** options, a number will appear next to the drop down menu indicating the icon size. You can manually type in a custom size, such as 72, which would give you icons half-way between medium and large.

### Step 3: Select Your Preferred Default Column Headings (Optional)

<img width="761" height="360" alt="image" src="https://github.com/user-attachments/assets/f58ea6bd-000b-4c47-a09f-facf048ac5b0" />

If you are happy with the default Details-view column headings (as shown on screen) then skip this step.

**Note**: Column headings shown in blue are only displayed in *search results* (by default). It is, therefore, recommended to keep the **Folder path** (**File location** in Windows 11) column heading.

<img width="761" height="360" alt="image" src="https://github.com/user-attachments/assets/4ceb1665-1849-4c43-ba40-550a0fe56b7d" />

Otherwise, click the **Columns** button to bring up the column headings selection page.

<img width="761" height="640" alt="image" src="https://github.com/user-attachments/assets/adc4f23b-c278-4650-846f-a5e689b24ab1" />

The column headings selection page allows you to select your desired column headings (and their order), group-by options, sort options, and column widths. The [manual](./Manual.md#columns) provides full details, but you can also hover over or click on elements to see how the interface works.

### Step 4: Set Views for Specific Folder Types (Optional)

<img width="761" height="580" alt="image" src="https://github.com/user-attachments/assets/a01023b8-65e1-46b2-8e51-21e240e35dcc" />

Please note that WinSetView allows you to set the default view for every folder type in Windows, but, by *default*, they will all get the same settings as your **Global** settings, as long as the **Inherit** box is checked.

For any folder type (e.g. **Pictures**) that you wish to have a *different* default view than your global setting, just scroll down to that particular folder type, *uncheck* the **Inherit** box, and repeat steps 2 and 3 for that folder type.

**Note**: You don't have to set the other similar folder types separately. For example, **Pictures Library** will use the same settings as **Pictures** as long as **Inherit** is checked for **Pictures Library**.

**Note**: If you *uncheck* a folder type, then that folder type will display with its Windows default view settings (i.e. the view you would get for a new user account).

### Step 5: Check and Set Your Desired Folder View Options (Required)

<img width="761" height="360" alt="image" src="https://github.com/user-attachments/assets/abae238b-01aa-465e-829e-e0f1a4185d6c" />

Click The **Folder View Options** button.

<img width="761" height="464" alt="image" src="https://github.com/user-attachments/assets/d8b467bb-0c32-4bb2-9720-c581fde04f14" />

The folder view options are applied together with the folder views on the main page. The default settings match Windows defaults. Click the 🔍 button to detect your current settings. See the [manual](./Manual.md#options-menu) for full details.

### Step 6: Check and Set Your Desired Explorer Options (Optional)

<img width="761" height="360" alt="image" src="https://github.com/user-attachments/assets/252745a6-0e67-4e67-8e83-4b8f50e4c6e6" />

Click The **Explorer Options** button.

<img width="761" height="796" alt="image" src="https://github.com/user-attachments/assets/eaf791d3-cf6e-4cfc-bd6c-8b701f0a75c6" />

You can choose to apply or exclude these options when **Submit** is clicked. Click the 🔍 button to detect your current settings. See the [manual](./Manual.md#options-menu) for full details.

**Note**: Options with a shield icon require Administrative access. A UAC prompt will appear when **Submit** and **Ok** are clicked, if there are any changes to be made.

### Step 7: Apply the Selections to Windows File Explorer

<img width="761" height="360" alt="image" src="https://github.com/user-attachments/assets/bfcbe6ad-a90d-46df-8d17-66f9665d1c0a" />

Once you're happy with your selections, click the **Submit** button. This will pop up a dalog where you can choose to **Clear folder views and set new defaults** and/or **Reset Explorer options**. Note that a backup of your current folder views will be made if **Backup** is checked.

**IMPORTANT**: Do not check **Reset Explorer options** unless you have reviewed the **Explorer Options** page and are sure of your selections. Otherwise, you may receive unwanted changes.

<img width="383" height="201" alt="image" src="https://github.com/user-attachments/assets/395c8287-bac9-42e1-ab6d-81fc56efc2dc" />

You can always run WinSetView again to change any settings and you can revert back to a previous state using the **Restore** button. You also have the option of setting File Explorer back to Windows defaults by checking **Reset Views to Windows Defaults** and then clicking **Submit**.

**IMPORTANT**: **Reset Views to Windows Defaults** only resets folder views. It does not revert the options listed in **Explorer options**. The **Restore** function will revert your folder views to what they were in the slected backup file and it will revert most of the **Explorer options**. Either way, it's recommended to carefully review the settings in **Explorer options** if you choose to apply them.

**Note**: A major Windows update or a full repair via Windows Update (e.g. running Setup.exe from the Windows ISO) will remove the `FolderTypes` registry key from HKEY_CURRENT_USER (i.e. it will undo the default folder views set by WinSetView). In such cases, simply run WinSetView again and click **Submit** to reapply your view preferences.

[![image](https://github.com/LesFerch/WinSetView/assets/79026235/50c53943-f673-49da-ad3f-419026deea96)<!--[-->See the complete user manual](./Manual.md)
\
\
\
[![image](https://github.com/LesFerch/WinSetView/assets/79026235/63b7acbc-36ef-4578-b96a-d0b7ea0cba3a)](https://github.com/LesFerch/WinSetView)

