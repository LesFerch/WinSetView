# WinSetView
<!--
To view this document formatted (instead of as raw text) just click the Help button in WinSetView.hta.
You can also manually navigate your browser to: https://lesferch.github.io/WinSetView.
-->

This is the complete user manual. See the link below for the quick start guide.

[![image](https://user-images.githubusercontent.com/79026235/152910441-59ba653c-5607-4f59-90c0-bc2851bf2688.png)Download the zip file](https://github.com/LesFerch/WinSetView/archive/refs/heads/main.zip)

![image](https://user-images.githubusercontent.com/79026235/152913587-d294de81-c8ca-428d-b351-09a564854eff.png)
[See the quick start guide](./README.md)


## Globally Set Explorer Folder Views

Compatible with Windows 7, 8, 10, and 11.

Les Ferch, lesferch@gmail.com\
GitHub repository created 2021-03-26, last updated 2022-04-07

# Summary

WinSetView provides an *easy* way to set Windows File Explorer default folder views. For example, if you want Details view, with a particular selection of column headings enabled across all folders, then WinSetView will do that for you. WinSetView sets registry values, as discussed in various websites online, that Explorer will use to let you get the folder views set up just the way you want. It does NOT modify File Explorer or add any tasks or services.

WinSetView is comprised of two main files: **WinSetView.hta** (HTML GUI with VBScript code) and **WinSetView.ps1** (PowerShell command line script) and numerous supporting files (see the Files section below for details). Double-click **WinSetView.hta** to open the GUI. When you click **Submit**, it will pass your choices as an INI file to WinSetView.ps1, which will make the registry changes and then restart Explorer.

Each option, and related Explorer background information, is detailed below, but if you just want to get to it, the interface is pretty much self-explanatory. For best results, close all open applications before running WinSetView. Open applications can prevent open/save dialog views from being updated.

All changes made by WinSetView are per-user within the HKEY_CURRENT_USER hive in the registry. No machine settings are touched and no elevated privileges are required. On each run, WinSetView makes a unique backup file of the affected registry values. A restore option is provided allowing you to rollback to any of these backups. There's also an option to completely reset all Explorer views to Windows default values.

**Note**: For USB-connected phones and tablets, WinSetView provides an option to have them displayed in the same view as generic (General Items) folders (e.g. Details view), but it cannot control the Details view column headings for such devices.

# Interface
![image](https://user-images.githubusercontent.com/79026235/152623653-b6834ebe-e40b-476c-b972-d69309e32f66.png)

## Help Button

Click the **Help** button to bring up a short tutorial for non-technical users. The tutorial also includes a link to this manual.

## Language Menu

Select an interface language for *WinSetView*. See the **Language Support** section below for details. This option does NOT change the Windows language.

Please note that changing language resets the display and loses any selections that have not been saved to the INI file (see *Save Settings* below).

## Interface Menu

Select **Standard** for the standard interface. Select **Advanced** to also see lesser-used features that may require reading this guide in order to understand their purpose.

## Font and Font Size Menus

Select a font and font size for the *WinSetView* interface. This has no affect on any setting in Windows.

The font list is read from the file **Fonts.txt** in the **AppParts** folder, which may be edited to include any font that is installed on your computer. The default list includes fonts that are typically found on all Windows computers and includes fonts to optimize the display for certain languages.

## Horizontal Scroll Control Menu

Adjust whether a long line in WinSetView is wrapped or scrolled horizontally. Values range from 1 (no horizontal scroll bar) to 9 (view port 9x wider than window). This has no affect on any setting in Windows.

## Reset Views to Windows Defaults

When checked, and applied via *Submit*, this option clears the registry keys that hold Explorer views and restarts Explorer, causing all folder views to revert to Windows defaults. To use this option, check the box and then click *Submit*.

## Submit

Execute the PowerShell script to apply the selected options to the registry and restart Explorer.

When *Submit* is clicked, the current selections in WinSetView are saved to an INI file (Win10.ini on Windows 10 and 11) and that INI file name is passed to WinSetView.ps1.

Hold down the **Alt** key when clicking **Submit** to keep the PowerShell console open after completion of the script. This is useful for debugging if any errors appear in the PowerShell console window.

See the **Background** section for details on how Explorer view settings work and how this script sets Explorer view default values.

## Options

Open the **Options** menu. See the *Options* section for details.

## Restore

Select and restore a backup file to return Explorer views to a previous state.

This button will be grayed out on first run. Each time you click *Submit*, the PowerShell script makes a backup of the user's Explorer view registry keys to a date-time-named file. The *Restore* button will bring up a dialog to let you pick a backup file to restore. Since it's a standard file dialog, you can use the same interface to delete any unwanted backups by selecting them and right-clicking to get a *Delete* option.

## Load Settings

(Advanced interface)

For *technical users*, who wish to maintain multiple configurations, the **Load Settings** button is used to *load* WinSetView interface selections from a previously saved INI file.

## Save Settings

(Advanced interface)

For *technical users*, who wish to maintain multiple configurations, the **Save Settings** button is used to *save* WinSetView interface selections to an INI file.

Please note that the INI file that is read on WinSetView startup and saved upon clicking *Submit*, is Win10.ini in Windows 10 and 11, so typically, you will want to save to Win10.ini.

When running WinSetView on Windows 7 and 8.x, it will use Win7.ini and Win8.ini respectively. Windows 7 and 8 have separate INI files because they support a smaller set of folder types and column headings than Windows 10 and 11.

## System Menus

The Minimize, Maximize and Exit controls work as they do in any application. Please note that when **X** is clicked, the script will exit without savings your selections. Your selections are saved when you click *Submit* or manually by using the *Save Settings* button.

## Global

Set the *Global* (system-wide) views for Windows:

Use the **View** menu to select one of: *Details, List, Tiles, Content, Small icons, Medium icons, Large icons, or Extra large icons*

The **Icon Size** size menu will display the icon size if you have chosen one of the icon views. This value may be edited. For example, if you enter 72, you will get an icon size half-way between medium (48) and large (96). If you set a custom size, it will NOT change the definition of small, medium, large, or extra large.

Note: In *Explorer*, you can use *Ctrl-Mouse-Scroll-wheel* to set a custom icon size and you can use the *Reset Folders* option in the *View* options to reset the view, including the icon size, to the values you set in WinSetView.

Use the **Columns** button to select column headings, group by, and sort by options. See the *Columns* section below for further information.

The selected column headings for *Details* view are shown on a single line with each heading separated by a vertical bar. If many headings are selected and/or a large font is used, this line will wrap. To view this line without wrapping, use the horizontal scroll menu, as described above. Column headings shown in *blue* are only displayed in search result views. See the *Options* page to toggle this feature on or off.

The **Group by** option applies to any view. Use the *Columns* button to select the property to group by or turn off grouping, which will be displayed as *(None)*.

The **Sort by** option applies to any view. Use the *Columns* button to select up to four properties to sort by. A plus sign indicates ascending order and a minus sign indicates descending order. By default, items will be sorted *ascending* by *Name*.

## Additional Settings for Each Folder Type

Below the *Global* section in WinSetView are settings for each Explorer folder type. See below for more information about the different folder types. Each folder type has settings as described above for *Global*, but also has these additional settings:

**Enable/Disable Check Box**

To the left of each folder type is a checkbox that is normally checked. If the box is unchecked, no settings will be changed for that folder type. That is, it will retain it's Windows default settings.

**Inherit**

The **Inherit** checkbox is very important. By default, this box is checked for all folder types. This means the folder type will get its settings from its parent folder type. With all Inherit boxes checked, all folder types will get the same settings as *Global*. Uncheck the Inherit button when you wish to have settings for a folder type that differ from its parent.

Please note that there are *groups* of folder types in WinSetView. For example, the parent of *General Items* is *Global* but the parent of *General Items Library*, *General Items OneDrive*, and *General Items Search Results* is the *General Items* folder type. The same pattern is true for *Documents*, *Music*, *Pictures*, *Videos*, and *Contacts*.

**Inspect (🔍)** (Advanced interface)

The 🔍 button is a feature for *technical users* that provides a quick, synchronized view of the folder type's default values in HKLM compared to the current values (if any) set in HKCU by WinSetView.

Note: For power users who have their own comparison tool installed, such as WinDiff or Beyond Compare, a before/after comparison can be done by going to the Windows Temp directory and comparing the files *WinSetView1.reg* and *WinSetView2.reg*.

## Folder Types

In Windows, there are five major folder types that most users are familiar with:

**General Items\
Documents\
Pictures\
Music\
Videos**

Any folder (or tree of folders) can be set to one of these folder types using Explorer's **Customize this folder...** menu and the view settings for a particular folder type can be updated from the currently viewed folder by using Explorer's **Apply to Folders** button. More information on these options is in the *Background* section later in this document.

In the Windows 10 *FolderTypes* registry key, there are actually **56** different folder types, of which **38** have view and column heading settings that can be edited by WinSetView. Ten of these folder types do not appear to affect anything useful or visible in Explorer, leaving **28** folder types that are shown in WinSetView.

Note: The file **FolderTypes.txt** file contains the list of all 38 of the editable folder types, but I have commented out 10 of those. If you see a reason why one or more of the commented out entries should be enabled for editing in WinSetView, please let me know.

## Folder Type List

**Downloads**

As of Windows 10 1903, the **Downloads** folder is its own folder type. This is a good thing, but the default setting of *group by date* has been a source of frustration for many users. Although WinSetView will let you change this default, it was always in the user's control to turn it off for the Downloads folder type. More details on this can be found in the *Background* section below.

You can leave *Inherit* checked and just let *Downloads* use your Global settings, or uncheck Inherit and select specific settings for this folder type. Be assured, either way, if you set *Group by* to *(None)* you will never see grouping in this folder again.

**General Items**

This is the folder type that applies to most folders on your computer's storage devices. It's also known as the *Generic* folder type. You will probably want to leave *Inherit* checked for this folder type to have it use your Global settings.

**Documents**

This folder type is for document files, such as Word and Excel files. For most users using the Global settings for documents works fine, but some users may want to uncheck *Inherit* on this folder type and add headings such as *Authors* or *Owner*.

**Music**

This folder type is for music files, such as MP3s. Therefore, you may want to enable headings such as *Rating*, *Bit rate*, *Length*, *Contributing Artists*, and *Genre*.

**Pictures**

This folder type is for pictures, such as JPGs. Many users like to set *Pictures* folders to a more visual display, such as large icons or add columns such as *Dimensions* to Details view. Uncheck *Inherit* if you want to set Pictures differently than your Global settings. If you want to have icons for Pictures folders in Explorer, but want List or Details view when opening or saving files in graphics programs, be sure to go to the *Options* menu to set the view for Open and Save dialogs.

**Videos**

This folder type is for videos, such as MP4s and MKVs. The comments for the Pictures folder type also apply to the Videos folder type.

**Contacts**

This folder can be found when you browse to your user folder in Windows. If you use *Windows Contacts*, your contacts will be shown here. A Details view with column headings such as *E-mail address*, *Cell phone*, *Home address*, etc. would make sense for this folder type. If you don't use Windows Contacts, you can safely leave this folder type to use your Global settings.

**Library folder types**

Under each folder type listed above, there is a corresponding *Library* folder type. This controls the view you see when the folder is accessed via *Libraries*.

**OneDrive folder types**

Under each folder type listed above, except Contacts, there is a corresponding *OneDrive* folder type. This controls the view you see for folders on Microsoft OneDrive.

**Search Results folder types**

Under each folder type listed above, there is a corresponding *Search Results* folder type. This controls the view you see after doing a search. This is where a property, such as *Folder Path*, is useful to show the path of any found item.

Note: Each of the folder type groups above (e.g. *Pictures*) is a family in WinSetView with the first member being the parent of the others. Therefore, for example, if you uncheck *Inherit* for the *Music* folder type and then edit its column headings, those settings will be inherited by all of the other *Music* folder types, as long as they have Inherit checked.

**Quick access**

This folder type controls the view you see when clicking on the *Quick access* item in Explorer's left navigation pane. This folder type is also known as the *Home Folder*.

**User Files**

This folder type controls the view you see for your user folder (e.g. C:\\Users\\SomeUser).

**User Files Search Results**

This folder type controls the view of results you see when you *search* your user folder.

**Searches**

This folder type controls the view you see for the *Searches* item within your user folder.

## Options Menu

![image](https://user-images.githubusercontent.com/79026235/152627497-79f752e9-181f-4678-98a2-dff10753ba5a.png)

**Show File Extensions**

By default, Windows hides file extensions for known file types. This is generally considered a bad idea for both usability and security (search the topic on the Internet for more details). Show File Extensions is checked by default in WinSetView.

\
**Enable compact view in Windows 11**

By default, Windows 11 spreads out items in list, details, and small icons views. This makes it easier to select items using a touch interface, at the expense of less information in the same space. Enabling *compact view* sets the spacing back to the tighter spacing used in Windows 10.

\
**Show paths in search results only**

When this option is checked, path and folder name column headings in Details view are only shown in search results. Such headings are shown in *blue*. The following column headings are affected by this setting:

**Folder path** (ItemFolderPathDisplay): Full path to the folder. Example: C:\Movies\Ghibli\
**Folder** (ItemFolderPathDisplayNarrow): Folder name followed by preceding path. Example: Ghibli (C:\Movies)\
**Path** (ItemPathDisplay): Full path to the file. Example: C:\Movies\Ghibli\Ponyo.mkv\
**Folder name** (ItemFolderNameDisplay): The folder name only. Example: Ghibli

Tip: Select your preferred search result path column first and then select other headings, such as Date modified and Size. That way, when you do a search, the path of all matches will be visible without having to make the window larger.

Note: The path column will not appear when you search the Downloads folder because the Downloads folder type does not have an associated search results folder type.

Note: The *Relevance* column heading (*Search.Rank* property) is *only* shown in search results and is therefore always blue in WinSetView, regardless of this setting.

\
**Use General Items view for connected devices**

Connected devices, such as phones and tablets, normally open in **Tiles** view with no option to easily change the view. The **Apply to folders** option is grayed out for such devices, requiring view changes to be done folder by folder. Enabling the **Use General Items view for connected devices** option causes such devices to open in the same view that has been set for **General Items**.

Please note that this option actually causes all virtual folders, that share the General Items GUID, such as **This PC**, to be displayed with the same view as **General Items**. However, the separate view settings, available for *This PC*, can be used to override the General Items view.

\
**Set views for Open and Save dialogs:**

This option allows you to set a specific view for Open and Save dialogs that overrides the view setting for any folder type.

For example, with the *Pictures* folder type set to large icons and this option *checked*, with *Details* selected, you will see Large icons when you browse to Pictures in Explorer, but you will see a Details view in and Open and Save dialogs in applications such as MSPaint.

\
**Set view for "This PC"**

If this option is checked, *This PC* will be set to the view selected. If this option is unchecked, this virtual folder will retain its Windows default of *Tiles* and group by *Type*.

**Note**: Because **This PC** does not have its own GUID, this option creates registry values (in the BagMRU/Bags keys) that would be the same as if you manually browsed to this folder and set the view. These settings are prone to returning to Windows defaults (see *Apply to Folders "Bug"* below).

\
**Set view for "Network"**

If this option is checked, *Network* will be set to the view selected. If this option is unchecked, this virtual folder will retain its Windows default of *Tiles* and group by *Category*.

**Note**: The **Network** virtual folder does not have a *FolderType* registry entry, but does have its own GUID, so this option creates registry values in the *AllFolders* registry key, which is not affected by the *Apply to Folders "Bug"*.

\
**Make All Folders Generic** (Advanced interface)

This option sets a registry value that tells Explorer to make all folders to be type *Generic* (i.e. *General Items*).

This makes the **Documents**, **Music**, **Pictures**, and **Videos** folders generic. Those folders will retain their special icons, but they will otherwise be generic (e.g. column headings in Details view will be the same as *General Items*). This option has no effect on the **Downloads** folder.

Please note that, even with this setting enabled, you can still change any folders to type **Documents**, **Music**, **Pictures**, or **Videos** using Explorer's **Customize this folder...** option. Any default views, you may have set for these folder types in WinSetView, would then apply.

Checking this option also causes **Folder Type Discovery** to be disabled. That's the windows feature that automatically changes a folder's type based on its contents. If you want your folder views to change with content, don't check this item. If you want a consistent view across all folders, regardless of content, you *may* want to check this option.

Please note there is no separate setting for **Folder Type Discovery**. If you want Folder Type Discovery *off*, you must make all folders generic. However, as noted above, you can change any folder (or tree of folders) back to a specific folder type at any time.

\
**Keep "Apply to Folders" Views** (Advanced interface)

WinSetView provides individual settings for each folder type, making this setting unnecessary. For most users, it will be simpler to set all folder views in *WinSetView* and leave this option **unchecked**.

This option retains any folder views that have been saved using Explorer's **Apply to Folders** button. With the earliest version of WinSetView, this was the only method available to keep some non-generic folder settings in addition to the Global settings. This option is now obsolete.

If you really want to use this option, be sure to use the **Apply to Folders** button in Explorer for each folder type view you want to set. That is, in *Explorer*, set your desired view for **Downloads**, then go to **View**, **Options**, **Change folder and search options**, **View** tab, and click **Apply to Folders**. Repeat those steps for **Documents**, **Music**, **Pictures**, and **Videos**. All of those views will then take precedence over any Global view set with *WinSetView*.

Note: If **Make All Folders Generic** is also checked, only **Downloads**, **Libraries**, and **Search Results** will get their views from any view saved via Explorer's **Apply to Folders** button. Of course, if you later change a folder to type **Documents**, **Music**, **Pictures**, or **Videos**, it will then pick up the view settings that were saved using **Apply to Folders**.

\
**Disable folder thumbnails** (Advanced interface)

This option sets a registry value that tells Explorer to NOT create a thumbnail icon for *folders*. It has no effect on thumbnails for *files*.

## Columns

![image](https://user-images.githubusercontent.com/79026235/152623377-22665b75-2dd2-4d33-a9ce-004ae19643a8.png)

Clicking the **Columns** button brings up the column (properties) selection page for the current folder type. Column headings, in Explorer Details view, correspond to file and folder *properties*.

The top left of the page shows the currently selected folder type (or *Global*).

The top right of the page has a back button (🡨) that will take you back to the main page. Please note that clicking the **X** in the System menu bar will exit the application, just as it does on the main page.

Next, the currently selected column headings, that will display in File Explorer's Details view, are shown on a single, scrollable line in the same *order* as they will appear in File Explorer.

This is followed by a list of all the Details view column headings that can be selected in Explorer (over 300 on Windows 10). These items are shown in the language of your choice, exactly as they appear in Explorer. Hovering the mouse over any name will show its internal Windows property name.¹

To the left of the column headings list are seven columns for selecting **Group by**, **Sort by**, **Width**, **Display**, and **Right-click** options. Each of these headings is also a button. Hovering the mouse over any heading button shows the button's heading text. Each of these columns is described below.

¹ For those running WinSetView in a language other than English, the property name may appear to be showing the "English translation", but that's not correct. The property names are *fixed* internal Windows values and are not necessarily a direct match to the display name. For example, the property *ItemFolderPathDisplayNarrow* is shown in Explorer Details view as *Folder* in English or *Ordner* in German. The display names can also vary from one release to another. For example, the property *Search.Rank* is shown as *Search ranking* in Windows 7 and *Relevance* in Windows 10.

\
**{ } (Group by)**

This column will be disabled by default and the button at the top of the column will appear as an **X**. In this mode, no property is selected for grouping (i.e. *Group by* = *None*). To enable the column, click the **X**. The button will switch to **{ }** and a column of radio buttons will appear. Select the radio button beside the property you wish to group by. Only one property can be selected. Clicking the heading button again will hide the radio buttons and set grouping to none.

\
**⮬ (Sort 1, Sort 2, Sort 3, Sort 4)**

There are four Sort columns to allow sorting Explorer file/folder views on up to four different properties. Click a Sort column heading button to cycle between *ascending* (**⮬**), *descending* (**⮯**), or *disabled* (**X**). The first Sort column cannot be disabled. That is, at least one property must be selected for sorting. By default, *Sort by* is set to the Name (ItemNameDisplay) property in *ascending* order.

With a Sort column enabled (ascending or descending), click a radio button beside the property you wish to sort by.

\
**⟷ (Column Width)**

This column allows you to set the default width for each property (column heading). For example, you can use this setting to make the Name column wider than the default of 34 ems.

The value is specified in ems. 1 em ≈ 1 char\
Em size is relative to screen scaling. For example (at 96 dpi):\
1 em at 100% = 8 pixels\
1 em at 125% = 10 pixels\
1 em at 150% = 12 pixels\
Explorer uses ems internally for all its default column widths. This keeps the amount of text displayed in each column constant as screen scaling is changed.

Please note that you can set the width as small as 1em, but Explorer will expand the column width to it's minimum allowed value when you drag the column width control in Explorer Details view. The minimum value cannot be overridden.

If you wish to enter the column width in *pixels*, hold **Alt** and **click** the input width field you wish to adjust. A dialog will open showing the width in pixels:

![image](https://user-images.githubusercontent.com/79026235/127723197-4b19497a-cf17-43e2-b7ac-df23e4b33608.png)

The pixel value will vary depending on screen pixel density, whereas the value in ems will be constant across different display configurations. Please note that WinSetView sets the column *default* width which can only be set to whole (integer) em values. Windows File Explorer lets you set the width down to the pixel, but that is stored as a setting within the volatile *Bags* registry key *overriding* the default value. WinSetView deals with *default* settings only.

If you click the **⟷** column heading button, it will prompt with an option to clear all column width fields.

\
**✓✓ (Display in Details View)**

This column provides checkboxes to allow you to select which column headings are displayed in Details view. Any column selected for Details view also becomes a quick-pick item when you right-click in the column heading bar in Explorer. Therefore, when you select an item in this column, it also checks the item in the *Add to Right-Click Menu* column.

If you *uncheck* an item in this column, it does not uncheck the item in the *Add to Right-Click Menu* column because an item can be available for quick-pick without being an active column heading.

\
**Column Order**: The *order* in which the selected columns are displayed in File Explorer is shown at the top of the screen. The order is simply based on click-order. To change the order, simply uncheck each item and then recheck them in the desired order.

Click the **✓✓** column heading to quickly uncheck *all* selected column headings.

\
**✓ (Add to Right-Click Menu)**

This column provides checkboxes to allow you to select which column headings are available for quick-pick when you right-click in the column heading bar in Explorer Details view.

The Explorer limit for the quick-pick menu is 21 items, so WinSetView will not allow you to select more than 21 items in this column. If you hit this limit, you will see this message:

![image](https://user-images.githubusercontent.com/79026235/124494511-eb6ad200-dd84-11eb-8198-adea1bb7e176.png)

Just click OK to close the message. Adjust your selections as necessary. You can't pick more than 21.

If you click the **✓** column heading button, it will prompt with an option to clear all selections in the column. This will also clear all selections in the *Display in Details View* column because it's not possible for a property to be a Details view column heading and not be in the quick-pick menu.

## Column Headings (Properties)

There are over 300 different file/folder properties available to select in Explorer Details view. These same properties are available to select in WinSetView. Please note that the display name for each property is shown in WinSetView exactly as it appears in Explorer. Some of these names are ambiguous. For example, the name *Status* appears three times. In the *Columns* page, you can move the mouse over any display name to see its internal property name, but often that still doesn't help explain it. For example, what exactly does *Link status* display? Some of the less obvious properties are related to certain Office applications, but some are a complete mystery. Just use the ones that work for you and ignore the rest.

In addition to the path-related properties explained earlier, here are explanations of some other common properties:

**Date Modified**: The last date/time the file was updated on this file system.\
**Date Created**: This is the date/time the file was initially written to storage.\
**Date accessed**: Date file was last opened (rarely accurate due to deferred updates).

**Size**: The file size in KB\
**Attributes**: File attributes such as Archive[A], Hidden[H], System[S], Read-only[R]\
**File Version**: Applicable to files that have a version header, such as .exe files\
**Owner**: File owner in computer\userid format

**Item type**: The file's type based on file extension. Example: MPEG Layer 3\
**Type**: Usually same as File type, but may show associated app name in search results.\
**Perceived type**: File category. Examples: Audio, Video\
**Kind**: Similar to Perceived type. Examples: Music, Video\
**Content type**: Essentially Perceived type + Item type. Example: audio/mpeg\
**File extension**: Example: .mp3 (handy for sorting if you don't need a type field)

Note: The **File extension** column heading is not available on Windows 7.

# Files

In addition to the two main files: **WinSetView.hta** (HTML GUI with VBScript code) and **WinSetView.ps1** (PowerShell command line script) the following folders and files are included:

## AppData Folder

This folder contains INI files which hold the options selected with the WinSetView interface. Due to the folder type and column heading (property) lists differing among Windows versions, there are separate INI files for Windows 7, 8, and 10. Windows 11 uses the same settings as Windows 10.

This folder will also contain a *Backups* folder after first run containing REG files that can be used with the Restore option to rollback to a previous state of Explorer view settings.

For system administrators and power users, please note that the *WinSetView.ps1* script will accept one INI file or one REG file as a command line parameter. You can also pass INI files to WinSetView.ps1 using *WinSetView.vbs* (which may be moved from Tools to AppData).

Please note, for system administrators setting up new users, it may be more efficient to capture the results of WinSetView to a REG file and apply that file using the command **reg import filename.reg** rather than running WinSetView for each new user. Two different scripts for capturing Explorer view settings to a REG file are provided in the Tools folder. See below for more details.

## AppParts Folder

This folder contains files that are required for *WinSetView.hta* to have full functionality.

The **Fonts.txt** file contains a list of fonts to display in the WinSetView font selection menu. If this file is missing, only the two currently selected fonts will be shown.

The **FileDialog.exe** file provides the open/save dialog used by WinSetView for the *Load Settings*, *Save Settings*, and *Restore* buttons. This executable is written in C#. The source code is FileDialog.cs.

## Language Folder

This folder must exist and contain the **en-US** folder and language files in order to run *WinSetView.hta*. All other language folders are optional. This folder is not needed for WinSetView.ps1.

## Tools Folder

WinSetView does NOT need the Tools folder to run. It contains supplemental tools for system administrators, power users, or anyone wishing to create another language translation for WinSetView.

**WinSetBack.ps1**

PowerShell script for backing up and restoring all Explorer view related settings. System administrators can use WinSetBack.ps1, after running WinSetView and making any further manual view settings, to back up all view settings to a single REG file. The REG file can be applied to a new user account with a simple REG IMPORT command.

**WinSetBack.cmd**

For those who prefer to go old school. This does the same thing as WinSetBack.ps1 except that it saves the backup to the desktop instead of the script's directory.

**CaptureCustom.vbs**

Whereas WinSetBack.ps1 captures ALL Explorer view-related keys, *CaptureCustom.vbs* captures only the *BagMRU*, *Bags*, and *Control Panel* keys to provide a supplemental file for use with WinSetView.

This script captures Explorer view settings that can't be set in WinSetView, such as *Recycle Bin* and *Control Panel* views. First run WinSetView to set your desired Explorer default view settings. Next, set Recycle Bin, Control Panel, etc. to your desired views and close those windows. Then run CaptureCustom.vbs. It will export the ControlPanel, BagMRU, and Bags keys to a file named CaptureCustom.reg.

Rename CaptureCustom.reg to WinSetViewCustom.reg and place it in the AppData folder to have it applied by WinSetView. WinSetView.ps1 will import the file WinSetViewCustom.reg after all other settings are applied. This will override any settings applied by WinSetView!

Please, if you don't know what you're doing, avoid this level of customization!

**StartRegeditClean.cmd**

A simple launcher for RegEdit that clears RegEdit's user settings key so that RegEdit starts up with all registry keys closed.

**MakeFontList.vbs**

This script generates a list of the currently installed fonts. It's useful for getting the correct font family names to put in WinSetView's *fonts.txt* file.

**PropertySystemView**

This is a tool from *NirSoft* that is used by the *MakeColumnList.vbs* script to get a list of all file and folder properties in the current system language.

**MakeColumnList.vbs**

This script creates a language-specific column heading (property) file for WinSetView's *Columns* page. This script must be run on a system that has the desired language installed and is currently running in that language.

**GetWinStrings.ps1**

This script extracts specific language strings from Windows for all installed languages that match up with the language folders in WinSetView. It creates the files *ViewList.txt* and *Strings.txt* in each language subfolder. The ViewList.txt files are used directly by WinSetView to create the View menu in each language. The Strings.txt file is used manually to correct the translated *FolderTypes.txt* files. That is, Strings.txt files contains the actual strings that Windows displays for the words *Downloads*, *General items*, *Documents*, *Music*, *Pictures*, *Videos*, *Contacts*, *Quick access*, *Searches*, *This PC*, and *Network* for each language.

**MakeFolderTypeList.vbs**

This script creates a language-specific *FolderTypes.txt* file for WinSetView's main page, using an online translator. The words in the *Strings.txt* file, generated by *GetWinStrings.ps1*, must then be used to edit the *FolderTypes.txt* file to correctly match the terms used in Windows for the given language.

**MakeLabels.vbs**

This script creates a language-specific *Labels.txt* file for WinSetView using an online translator. The words in the *Strings.txt* file, generated by *GetWinStrings.ps1*, must then be used to edit the *Labels.txt* file to correctly match the terms used in Windows for the given language.

# Background

Folder views in Windows Explorer are both flexible and, sometimes, frustrating. Many users have reported their view settings getting inexplicitly reverted back to Windows defaults, especially as it concerns the *Downloads* folder. However, some of these frustrations may be due to a misunderstanding of how the views work.

In Explorer, there are separate views for each folder type and often multiple folders that point to the same physical location. See the *Downloads Folder* section below for more details on this topic. Understanding Explorer's **Apply to Folders**, **Reset Folders**, and **Customize this folder...** features is key to getting control over Explorer's folder views.

WinSetView makes it *much* easier to get the views you want in Explorer across all folders, but it's still useful to understand how to set the views using Explorer only.

## Apply to Folders

The **Apply to Folders** button can be found in **View**, **Options**, **Change folder and search options**, **View** tab. Many users interpret this button to mean "Apply to ALL folders". That's not what it means. It actually means "Apply to all folders that are the same type as the current folder".

This button can be used to set a consistent view for a given folder type, such as the *Pictures* or *Downloads* folder types. It does not, however, provide an option to set folders of different types to a single *global* view.

## Reset Folders

The **Reset Folders** button can be found in the same place as the **Apply to Folders** button. It will reset all folders, that are the same type as the current folder, to Windows default views for that folder type.

If WinSetView was used to set the folder type default views, **Reset Folders** will revert the folder views to the settings you selected in WinSetView.

## Customize this folder...

The **Customize this folder...** menu item allows you to change the current folder (and optionally all of its subfolders) to one of the five major folder types. This can be used in any standard folder, but cannot be used in special folders, such as libraries.

To use this option, click in a folder's white space, select **Customize this folder...**, select the desired folder type, such as *Pictures*, from the menu, check **Also apply this template to all subfolders** (if you want the change to apply to subfolders), and then click **Apply**. This will change the folder's type and it will then be displayed using the view settings for that folder type.

## General Items (Generic) Folders

Without WinSetView, you can get closer to a global view by setting a generic folder, such as C:\\, to your desired views and then use the **Apply to Folders** button to set all other generic folders the same. But, by default, there are many folders that are not generic folders. To get even closer to a global view, you can set a registry value that will make most folders become generic (i.e. type *General items*). That registry value is:

    [HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell]
    "FolderType"="Generic"

Note:
* You can substitute *Generic* with *NotSpecified* and get the same result.
* WinSetView makes this registry entry for you (if desired). It's only shown here for educational purposes.

With the above registry value set, changing the view for a generic folder, such as C:\\, and then clicking the **Apply to Folders** button will also change the view for *Documents*, *Music*, *Pictures*, and *Videos* because they will all be *General items (Generic)* type folders.

Please note that the *Generic* registry setting has no affect on the *Downloads* folder. It will always remain its own unique folder type.

## Automatic Folder Type Discovery

By default, Explorer has automatic folder type discovery *enabled*. This means Explorer will automatically change a folder's type (and hence its view) based on its contents. The "FolderType"="Generic" registry entry, described above, also disables automatic folder discovery. This setting is applied by WinSetView when you select the **Make All Folders Generic** option.

If you want the folders *Pictures*, *Videos*, etc. to have the same view as *General Items*, then it will make sense to check the **Make All Folders Generic** option in WinSetView. However, if you want different views for these folders, it's probably not worth the trouble to check *Make All Folders Generic* just to turn off automatic folder type discovery. See this topic in the **FAQ** section for more details.

## Downloads Folder

Many users have been frustrated by the default setting of the *Downloads* folder type that groups files by *Date Modified*. After finding the *Group by* setting and changing it to *(None)* they are frustrated to see the grouping "come back". In most cases, the *Group by* setting did *not* come back, but the user is simply looking at a different view of the Downloads folder. That's where the confusion about Explorer's folder type design comes into play.

It's logical to assume that if one sets the view for a folder it shouldn't matter how ones gets to that folder, but in Explorer it does. A different route to a folder will sometimes mean that you are actually opening a different folder that points to the same place. Since it's a different folder, it has it's own view. However, all of these different folders are of the same *folder type* so, all that's required to set *Group by* to *(None)* for all of them is to set one and then use Explorer's **Apply to Folders** button to apply the change to all folders of the same type. This is the vital step that many users miss.

## Different Views Can Be Useful

While most users are simply annoyed by seeing a folder, such as *Downloads*, appear with different views, depending on how they get there, having the option to have different views permanently set up to the same location can be useful.

For example, you may find it useful to set *Pictures* to Details view with column headings, such as *Dimensions* and *Tags*, enabled and then set *Pictures Library* to large icons. This will give you the option to see any folder within Pictures in two different views without having to set that up every time.

## Apply to Folders "Bug"

Whenever you use the **Apply to Folders** button, on any generic folder, such as C:\\, your views for **This PC** (and USB connected phones and possibly other virtual folders) will revert back to Windows *defaults*. If you always leave **This PC** (and other devices) at their default views, this is not an issue, but if you have changed the views and want to keep them changed, avoid using **Apply to Folders** on generic folders. Instead, use **WinSetView** if you want to change your General Items (generic) folder view settings.

# FAQ

## How is WinSetView better than Explorer's "Apply to Folders"?

That option only applies your changes to folders of the *same type*. Explorer has many folder types, (e.g. Downloads, Pictures, Search Results, etc.), requiring you to set your desired view options repeatedly. Additionally, many users encounter situations where their selected options are reverted back to Windows defaults for no obvious reason. WinSetView allows you to make quick *global* changes to your view settings that will not unexpectedly change because it sets *default* views (per user).

## Can I use Explorer's "Apply to Folders" option in combination with WinSetView?

Yes. See the section above that describes the **Keep "Apply to Folders" Views** feature. However, you may find it easier to leave this option unchecked and set your desired views for all folder types in WinSetView.

## Does WinSetView require administrative privileges?

No. WinSetView creates a copy of the Windows folder view defaults, edits that copy, and applies it to the current user. The changes do not affect other users and are only part of the current user's profile.

## Is there an Undo?

Yes, as described under *Restore* above, WinSetView creates a backup every run that can be restored at any time. You can also revert the Explorer views to Windows defaults at any time.

## How can I disable automatic folder type discovery and keep special folder types, such as Pictures?

Select your desired options in *WinSetView*, including all desired views for *Pictures*, *Videos*, etc.

Check the option **Make all folders generic** and then click **Submit**.

In *Explorer*, open your *Pictures* folder, click in the white space, select **Customize this folder...**, select *Pictures* from the menu, check **Also apply this template to all subfolders**, and click **Apply**. Repeat this step for any other folder trees that you wish to set as *Pictures*. Repeat, similarly, for *Documents*, *Music*, and *Videos* folder types.

If you run WinSetView again with *Make all folders generic* checked, you will have to do the *Customize this folder...* procedure again to get your custom views for Pictures (and other special folders) to reappear.

For most users, who want to keep special folders such as *Pictures*, it's simpler to leave automatic folder type discovery enabled, set up all the folder types with your preferred views in WinSetView, and use **Customize this folder...** for the occasional folder that switches to an undesired folder type.

## How does WinSetView work?

To answer that question, let's first look at how Explorer selects the views for your folders...

When a folder is opened, Explorer looks for existing view settings in the BagMRU/Bags keys:

    HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU
    HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags

If no settings exist there, it then checks the Streams\Defaults key for any default settings that have been applied using the **Apply to Folders** button:

    HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults

If the view settings are not in the Streams\Defaults key, it checks the *FolderTypes* key in HKEY_LOCAL_MACHINE for the default view settings for the folder type that was just opened and applies those settings:

    HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes

Explorer then saves the settings in an entry in the user's BagMRU/Bags keys that will be updated whenever the user changes the view for that folder.

Fortunately for us, Explorer will also look for the *FolderTypes* key in HKEY_CURRENT_USER and, if it exists, use that instead of the one in HKLM:

    HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes

This provides an opportunity to set our desired default settings without touching the base defaults for the machine and all other users (and not requiring admin privileges).

Note: Default views for all folder types can be found in the *FolderTypes* key, with the exception of virtual folders such as *This PC*, *Network*, *Recycle Bin*, and *Control Panel*.

**How WinSetView Works**:

Here's an overview of the steps the PowerShell script performs to set Explorer views as per the selected options:

1) Backup the existing user's registry keys that hold Explorer views
2) Delete those keys (except *Streams/Defaults* if *Keep "Apply to Folders" Views* is checked).
3) Set any direct registry entries, such as *Show File Extensions* and *Make All Folders Generic*, for the current user.
4) If custom *This PC and/or Network* views have been selected, create registry entries for those views.
5) Copy FolderTypes key from HKEY_LOCAL_MACHINE (HKLM) to HKEY_CURRENT_USER (HKCU).
6) Edit FolderTypes key in HKCU per user's selections.
7) Restart Explorer.

# Language Support

WinSetView is designed to work with any left to right language. There are currently 31 languages included with WinSetView. If your language is not included, please contact me.

I have not included any right to left languages, such as Arabic, with WinSetView, as I'm not sure if that would be useful. However, if a native speaker tells me it would still be helpful to have their right to left language included, I will certainly add the language.

## Language Files 

The **WinSetView.hta** script looks for a **Language** folder in the same location as the script. The Language folder contains one folder for each supported language (e.g. *en-US*). Within each language folder are the following files:

*Columns-Win10.txt\
Columns-Win7.txt\
Columns-Win8.txt\
FolderTypes.txt\
Font.txt\
Labels.txt\
ViewList.txt*

If you wish to edit an existing language, you only need to touch the files *Labels.txt* and *FolderTypes.txt*. The *Columns* and *ViewList* files contain language strings pulled directly from Windows, so they are already perfectly matched to what Explorer displays.

The *Font.txt* file contains the default display font for the language. 

If you edit *FolderTypes* and *ViewList* please be sure to use EXACTLY the same terms that Windows uses. As described in the *Tools* section, the *GetWinStrings.ps1* script will extract key words from Windows for any installed language.

The *Tools* section provides details about which scripts and procedures create the various language files. However, I suggest that if you wish to create a new translation, please contact me and I will create all the files so you only have to edit the two machine translated files.

## Language Contributions 

Wherever possible, translated text is pulled directly from Windows (e.g. column headings). Some languages have had the benefit of human translation, but many have been done using online translation software and could use improvement from a native speaker. If you can help with a translation, please contact me!

Please see the Acknowledgment section for any language files that have been hand-corrected.

Please refer to the *en-US* folder when creating or editing a translation.

Save all edited language files as type **Unicode (UTF-16)**.

# Acknowledgements

Thanks to **Keith Miller** at TenForums.com for documenting the FolderTypes approach to setting default views.

Thanks to **Patrick Hannemann** for the German (de-DE) translation.

Thanks to **Ringo Xue** for the Simplified Chinese (zh-CN) translation.

Thanks to my daughter **Dana** for the Japanese (ja-JP) translation.

Thanks to my son **Brian** for HTML/CSS help. If you use Spotify on Android, please check out his  [**Trimify**](https://play.google.com/store/apps/details?id=app.web.trimifymusic) app on the Google Play store.

Thanks to my cat **Puddles** for keeping me company while I worked on this.

\
[![image](https://user-images.githubusercontent.com/79026235/153264696-8ec747dd-37ec-4fc1-89a1-3d6ea3259a95.png)](https://github.com/LesFerch/WinSetView)