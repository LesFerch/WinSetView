# WinSetView
<!--
To view this document formatted (instead of as raw text) just click the Help button in WinSetView.hta.
You can also manually navigate your browser to: https://lesferch.github.io/WinSetView.
-->

This is the quick start guide. For more details, please see the [complete user manual](./Manual.md).

[![image](https://user-images.githubusercontent.com/79026235/152910441-59ba653c-5607-4f59-90c0-bc2851bf2688.png)Download the zip file](https://github.com/LesFerch/WinSetView/archive/refs/heads/main.zip)

## Globally Set Explorer Folder Views

Compatible with Windows 7, 8, 10, and 11.

[Version 2.53](./VersionHistory.md)

# Summary

WinSetView provides an easy way to set Windows File Explorer default folder views. For example, if you want Details view, with a particular selection of column headings enabled across all folders, then WinSetView will do that for you.

# How to Download and Run

## Quick Instructions

1. Download the zip file using the link above.
2. Extract the entire zip file.
3. Run **WinSetView.hta**.
4. At the UAC prompt, uncheck **Always ask before opening this file** and then click **Run**.

**Note**: If **WinSetView.hta** does not open, or you get something other than the expected UAC prompt, ensure that the **HTA** file extension is associated with **Microsoft (R) HTML Application host** (MSHTA.exe).

For detailed instructions, please see: [Download Help Guide](./DownloadHelp.md)

# How to Use

Simple step by step instructions follow.

**Note**: Nothing in Windows is changed, and no settings are saved, until the **Submit** button is pressed. Feel free to experiment with the WinSetView interface and just **X** out and restart the app to get back to where you started. Display options such as **font**, **font size**, and **theme** are also saved to the INI file and are therefore also only saved when you click **Submit**. Only the WinSetView window size and position are saved automatically when you click **X** to exit the app.

For complete details, please see the [manual](./Manual.md).

## Step 1: Select Your Interface Language (Optional)

![image](https://user-images.githubusercontent.com/79026235/206563088-85288970-e666-4824-8b54-07ff83e01c54.png)

WinSetView should open in the same language to which you have Windows set. If not, select the correct language from the drop down menu.

## Step 2: Select Your Preferred Default View

![image](https://user-images.githubusercontent.com/79026235/206563583-ded1543d-0acb-4229-9129-b7f98abc6ee9.png)

Select the default view you want applied to most (or all) folders from the drop down menu under the **Global** heading. Most users go with **Details**, but pick what *you* like as your default.

**Note**: If you choose one of the **icons** options, a number will appear next to the drop down menu indicating the icon size. You can manually type in a custom size, such as 72, which would give you icons half-way between medium and large.

## Step 3: Select Your Preferred Default Column Headings (Optional)

![image](https://user-images.githubusercontent.com/79026235/206564056-d32f1e30-324a-4aa0-8e0d-98834b0725a2.png)

If you are happy with the default Details-view column headings (as shown on screen) then skip this step.

**Note**: Column headings shown in blue are only displayed in *search results* (by default). It is, therefore, recommended to keep the **Folder path** (**File location** in Windows 11) column heading.

![image](https://user-images.githubusercontent.com/79026235/206564277-95e4619e-8799-4f0e-afa3-eddcdadb6407.png)

Otherwise, click the **Columns** button to bring up the column headings selection page.

![image](https://user-images.githubusercontent.com/79026235/207390444-83f4aaff-4425-4b61-9d86-617dddbbbfe9.png)

The column headings selection page allows you to select your desired column headings (and their order), group-by options, sort options, and column widths. The [manual](./Manual.md) provides full details, but you can also hover over or click on elements to see how the interface works.

## Step 4: Set Views for Specific Folder Types (Optional)

![image](https://user-images.githubusercontent.com/79026235/206572556-a0fdda21-b3e8-4743-9a4c-a1543417ecdd.png)

Please note that WinSetView allows you to set the default view for every folder type in Windows, but, by *default*, they will all get the same settings as your **Global** settings, as long as the **Inherit** button is checked.

For any folder type (e.g. **Pictures**) that you wish to have a *different* default view than your global setting, just scroll down to that particular folder type, *uncheck* the **Inherit** button, and repeat steps 2 and 3 for that folder type.

**Note**: You don't have to set the other similar folder types separately. For example, **Pictures Library** will use the same settings as **Pictures** as long as **Inherit** is checked for **Pictures Library**.

**Note**: If you *uncheck* a folder type, then that folder type will display with its Windows default view settings (i.e. the view you would get for a new user account).

## Step 5: Check and Set Your Desired Options

![image](https://user-images.githubusercontent.com/79026235/206564644-a5ae3e5b-7f64-4db8-a4e2-6ae3f4f28728.png)

Click The **Options** button.

![image](https://user-images.githubusercontent.com/79026235/206564999-9aa1cef3-2cb0-4e46-9c4e-d49f8783c386.png)

Review the settings on that page and adjust as desired. See the [manual](./Manual.md) for full details.

## Step 6: Apply the Selections to Windows File Explorer

![image](https://user-images.githubusercontent.com/79026235/206563746-57bb1482-3a7c-4687-85dd-454376753f67.png)

Once you're happy with your selections, make those settings apply to Windows File Explorer by clicking the **Submit** button.

You can always run WinSetView again to change any settings and you can revert back to a previous state using the **Restore** button. You also have the option of setting File Explorer back to Windows defaults by checking **Reset Views to Windows Defaults** and then clicking **Submit**.

**Note**: If you use the **Reset Views to Windows Defaults** feature, be sure to check the settings under **Options**.

![image](https://user-images.githubusercontent.com/79026235/152911332-6492dd9e-63fa-4f38-8325-335110cbb9a6.png)
[See the complete user manual](./Manual.md)

\
\
[![image](https://user-images.githubusercontent.com/79026235/153264696-8ec747dd-37ec-4fc1-89a1-3d6ea3259a95.png)](https://github.com/LesFerch/WinSetView)
