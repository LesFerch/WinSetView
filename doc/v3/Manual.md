# WinSetView
<!--
To view this document formatted (instead of as raw text) just click the Help button in WinSetView.
You can also manually navigate your browser to: https://lesferch.github.io/WinSetView.
-->

This is the complete user manual. See the link below for the quick start guide.

![image](https://github.com/LesFerch/WinSetView/assets/79026235/41afd0e5-72c9-40e3-a1a0-fbb4dc591de9)
[See the quick start guide](./README.md)


### Globally Set Explorer Folder Views

Compatible with Windows 7, 8, 10, and 11.  Click [here](./System-Requirements.md) for system requirements.

Les Ferch, lesferch@gmail.com, 2021 - 2025

[Version 3.1.3](./VersionHistory.md)

## Summary

WinSetView provides an easy way to set Windows File Explorer default folder views. For example, if you want Details view, with a particular selection of column headings enabled across all folders, then WinSetView will do that for you. WinSetView sets registry values that File Explorer already supports. It does not modify Explorer or add any tasks or services.

**Note**: WinSetView does NOT scan your disk and set views for individual folders. It actually clears all saved views and sets new DEFAULT views in the registry. When you next open a folder, Explorer displays it using the default view that it reads from the registry.

WinSetView is comprised of two main files: **WinSetView.exe** (HTML application) and **WinSetView.ps1** (PowerShell command line script) and numerous supporting files (see the Files section below for details). Double-click **WinSetView.exe** to start the app.

Clicking **Submit** passes your choices as an INI file to WinSetView.ps1 which will make the registry changes and then restart Explorer.

Each option, and related Explorer background information, is detailed below, but if you just want to get to it, the interface is pretty much self-explanatory.

**IMPORTANT**: For best results, close all open applications before running WinSetView. Open applications can prevent open/save dialog views from being updated. Please note that some apps, such as Discord, Steam, and qBittorrent, don't actually close when you click the close box. Instead, they minimize to the System Tray. They're still running and that can prevent the file open/save dialog view from being updated. Fully exit the app (usually by right-clicking the icon in the System Tray and selecting `Exit`) to ensure that the file open/save dialog view will get updated.

All changes made by WinSetView are per-user within the HKEY_CURRENT_USER hive in the registry. No machine settings are touched and no elevated privileges are required (except as noted for a few optional settings). On each run, if **Backup** is checked, WinSetView makes a unique backup file of the affected folder view registry values. A restore option is provided allowing you to rollback to any of those backups. Please note that the backup does not include all items shown on the **Explorer Options** page.


## Interface

![image](https://github.com/user-attachments/assets/3e679e19-7444-4d3c-aa54-b5e350818ec7)

**Note**: For Windows 7 and 8, some of the icons used in the program will differ from Windows 10 and 11 due to issues with those older Windows versions being able to display all Unicode characters.

**Note**: Nothing in Windows is changed, and no settings are saved, until the **Submit** button is pressed. Feel free to experiment with the WinSetView interface and just **X** out and restart the app to get back to where you started. Display options such as **font**, **font size**, and **theme** are saved to the INI file and are therefore only saved when you click **Submit**. Only the WinSetView window size and position are saved automatically when you click **X** to exit the app.

## Buttons and Controls in the Header

### Help Button

Click the **Help** button to bring up a short tutorial for non-technical users. The tutorial also includes a link to this manual.

### ⛶ (Re-center) Button

WinSetView remembers its window size and position. Click the re-center button to move and resize the WinSetView window back to its default of centered, full height on the primary display. Pressing any function key (i.e. **F1** - **F12**) will also re-center the window. This can be handy if WinSetView has loaded off-screen (e.g. due to a change of monitors or their position).

### Language Menu

Select an interface language for *WinSetView*. See the **Language Support** section below for details. This option does NOT change the Windows language.

Please note that changing language resets the display and loses any selections that have not been saved to the INI file (see *Save Settings* below).

### Interface Menu

Select **Standard** for the standard interface.

The **Advanced** interface is of little interest to most users. It only hides the feature that lets you peek at the FolderType registry keys and hides buttons that are only useful if you are maintaining multiple INI files.

### Font and Font Size Menus

Select a font and font size for the *WinSetView* interface. This has no affect on any setting in Windows.

The font list is read from the file **Fonts.txt** in the **AppParts** folder, which may be edited to include any font that is installed on your computer. The default list includes fonts that are typically found on all Windows computers and includes fonts to optimize the display for certain languages.

### Horizontal Scroll Control Menu

Adjust whether a long line in WinSetView is wrapped or scrolled horizontally. Values range from 1 (no horizontal scroll bar) to 9 (view port 9x wider than window). This has no affect on any setting in Windows.

### Theme Menu

Select a light or dark theme for the WinSetView display. Theme definitions are located in .\AppParts\Themes.ini. The provided themes can be edited and/or new themes can be added.

### Reset Views to Windows Defaults

When checked, and applied via **Submit**, this option clears the registry keys that hold Explorer views and restarts Explorer, causing all folder views to revert to Windows defaults. To use this option, check the box and then click **Submit**.

**Note**: This feature does NOT reset the **Explorer Options** items to Windows defaults. Those settings will be applied, as currently selected, if **Reset Explorer options** is checked in the **Submit** dialog.

### Backup

If this box is checked, a REG file backup will be made of your current folder views plus any Explorer options that are listed in Explorer's Folder Options View tab.

### Submit

This will open a dalog where you can choose to **Clear folder views and set new defaults** and/or **Reset Explorer options**. 

When **OK** is clicked, the current selections in WinSetView are saved to an INI file (Win10.ini on Windows 10 and 11) which is then passed to the **WinSetView.ps1** PowerShell script. That script will apply the selected options and restart Explorer.

**Important**: Do not click OK when Explorer is busy copying/moving/deleting files.

Hold down the **Alt** key when clicking **OK** to keep the PowerShell console open after completion of the script. This is useful for debugging if any errors appear in the PowerShell console window.

See the **Background** section for details on how Explorer view settings work and how this script sets Explorer view default values.

### Folder View Options

Open the **Folder View Options** page. See the *Folder view Options* section for details.

### Explorer Options

Open the **Explorer Options** page. See the *Explorer Options* section for details.

### Restore

Select a backup file to return Explorer views to a previous state.

This button will appear after the first run (i.e. after **Submit** and **OK** has been clicked) with the **Backup** option checked. The **Restore** button will bring up a dialog to let you pick a backup file to restore. Since it's a standard file dialog, you can use the same interface to delete any unwanted backups by selecting them and right-clicking to get a *Delete* option.

**IMPORTANT**: The primary purpose of the WinSetView backup and restore is to allow reverting back to a previous state of Explorer folder views. Restore can only revert items shown in WinSetView's **Explorer Options** page that correspond to Explorer's Folder Options **View** tab.

### Load Settings (📄)

(Advanced interface)

For *technical users*, who wish to maintain multiple configurations, the **Load Settings** button is used to *load* WinSetView interface selections from a previously saved INI file.

This button does NOT load your current Windows settings. It's of no interest to most users!

### Save Settings (📝)

(Advanced interface)

For *technical users*, who wish to maintain multiple configurations, the **Save Settings** button is used to *save* WinSetView interface selections to an INI file.

This button does NOT save your current Windows settings. It's of no interest to most users!

### System Menus

The Minimize, Maximize and Exit controls work as they do in any application. Please note that when **X** is clicked, the script will exit without savings your selections. Your selections are saved when you click *Submit* or manually by using the *Save Settings* button.


## Folder Types

**Note**: The headings labelled "Downloads", "Picture", "Documents", etc. represent folder TYPES. They do NOT refer to the actual physical folders by those same names. Of course, if you set a view for the folder type "Pictures", Explorer will apply that view to the actual "Pictures" folder because that is its type.

### Global

Set the *Global* (system-wide) views for Windows:

Use the **View** menu to select one of: *Details, List, Tiles, Content, Small icons, Medium icons, Large icons, or Extra large icons*

The **Icon Size** size menu will display the icon size if you have chosen one of the icon views. This value may be edited. For example, if you enter 72, you will get an icon size half-way between medium (48) and large (96). If you set a custom size, it will NOT change the definition of small, medium, large, or extra large.

Note: In *Explorer*, you can use *Ctrl-Mouse-Scroll-wheel* to set a custom icon size and you can use the *Reset Folders* option in the *View* options to reset the view, including the icon size, to the values you set in WinSetView.

Use the **Columns** button to select column headings, group by, and sort by options. See the *Columns* section below for further information.

The selected column headings for *Details* view are shown on a single line with each heading separated by a vertical bar. If many headings are selected and/or a large font is used, this line will wrap. To view this line without wrapping, use the horizontal scroll menu, as described above. Column headings shown in *blue* are only displayed in search result views. See the *Options* page to toggle this feature on or off.

The **Group by** and **Sort by** options apply to any view. Their current settings are shown on the main screen, but you must use the **Columns** button to change them.

You can group by any property in ascending or descending order, or turn off grouping altogether, which will be displayed as *(None)*. Sorting can be set on one or more properties. A plus sign indicates ascending order and a minus sign indicates descending order.

The **⚙ (Options)** button allows you to select a _different_ view for File Open/Save dialogs. For example, if you have set **List** as your default view, but want **Details** in File Open/Save dialogs, this is where you would set that up.

![image](https://github.com/user-attachments/assets/897e702b-fec1-4c8f-86f6-bca3ae1a347e)

Separate File Dialog views can be set under Global as well as under any specific folder type.

Note that there is no need to set this option if you want Open/Save dialogs to have the same view you have already set for File Explorer.

### Additional Settings for Each Folder Type

Below the *Global* section in WinSetView are settings for each Explorer folder type. See below for more information about the different folder types. Each folder type has settings as described above for *Global*, but also has these additional settings:

**Enable/Disable Check Box**

To the left of each folder type is a checkbox that is normally checked. If the box is unchecked, no settings will be changed for that folder type. That is, it will retain its Windows default settings. This will NOT retain any user set views. Any folders of this type will revert to whatever the Windows default view is for that folder type.

If the **Advanced** interface is enabled, there is also a checkbox beside **Global**. This checkbox can be used to enable or disable ALL folder types with one click. This may be useful if you wish to leave the majority of folder types at their Windows default views and just set a select few to new default views.

**Inherit**

The **Inherit** checkbox is very important. By default, this box is checked for all folder types. This means the folder type will get its settings from its parent folder type. With all Inherit boxes checked, all folder types will get the same settings as *Global*. Uncheck the Inherit box when you wish to have settings for a folder type that differ from its parent.

Please note that there are *groups* of folder types in WinSetView. For example, the parent of *General Items* is *Global* but the parent of *General Items Library*, *General Items OneDrive*, and *General Items Search Results* is the *General Items* folder type. The same pattern is true for *Documents*, *Music*, *Pictures*, *Videos*, and *Contacts*.

**Inspect (🔍)** (Advanced interface)

The 🔍 button is a feature for *technical users* that provides a quick, synchronized view of the folder type's default values in HKLM compared to the current values (if any) set in HKCU by WinSetView.

Note: For power users who have their own comparison tool installed, such as WinMerge or Beyond Compare, a before/after comparison can be done by going to the Windows Temp directory and comparing the files *WinSetView1.reg* and *WinSetView2.reg*.

**Copy (📋)**

Click the Copy button to copy the settings for that folder type to the copy buffer.

**Paste (🖌️)**

Click the Paste button to replace the folder type's settings with the settings in the copy buffer.

### Folder Types

In Windows, there are five major folder types that most users are familiar with:

**General Items\
Documents\
Pictures\
Music\
Videos**

Any folder (or tree of folders) can be set to one of these folder types using Explorer's **Customize this folder...** menu and the view settings for a particular folder type can be updated from the currently viewed folder by using Explorer's **Apply to Folders** button. More information on these options is in the *Background* section later in this document.

In the Windows 10 *FolderTypes* registry key, there are actually **56** different folder types, of which **38** have view and column heading settings that can be edited by WinSetView. Ten of these folder types do not appear to affect anything useful or visible in Explorer, leaving **28** folder types that are shown in WinSetView.

Note: The file **FolderTypes.txt** file contains the list of all 38 of the editable folder types, but I have commented out 10 of those. If you see a reason why one or more of the commented out entries should be enabled for editing in WinSetView, please let me know.

### Folder Type List

**Downloads**

As of Windows 10 1903, the **Downloads** folder is its own folder type that has an annoying default setting of *group by date*. More details on this can be found in the *Background* section later in this document. WinSetView will not only let you override that default, but will also reset all current views that are grouped.

You can leave *Inherit* checked and just let *Downloads* use your Global settings, or uncheck Inherit and select specific settings for this folder type. Be assured, either way, if you set *Group by* to *(None)* you will never see grouping in this folder again.

**Note**: In Windows 10, only the Downloads root is type "Downloads". In Windows 11, all subfolders of Downloads are also type "Downloads".

**General Items**

This is the folder type that applies to most folders on your computer's storage devices. It's also known as the *Generic* folder type. You will probably want to leave *Inherit* checked for this folder type to have it use your Global settings.

**Documents**

This folder type is for document files, such as Word and Excel files. For most users using the Global settings for documents works fine, but some users may want to uncheck *Inherit* on this folder type and add headings such as *Authors* or *Owner*.

**Music**

This folder type is for music files, such as MP3s. Therefore, you may want to enable headings such as *Rating*, *Bit rate*, *Length*, *Contributing Artists*, and *Genre*.

**Pictures**

This folder type is for pictures, such as JPGs. Many users like to set *Pictures* folders to a more visual display, such as large icons or add columns such as *Dimensions* to Details view. Uncheck *Inherit* if you want to set Pictures differently than your Global settings. If you want to have icons for Pictures folders in Explorer, but want List or Details view when opening or saving files in graphics programs, be sure to click the **⚙** (Options) button to set the view for Open and Save dialogs.

**Videos**

This folder type is for videos, such as MP4s and MKVs. The comments for the Pictures folder type also apply to the Videos folder type.

**Contacts**

This folder can be found when you browse to your user folder in Windows. If you use *Windows Contacts*, your contacts will be shown here. A Details view with column headings such as *E-mail address*, *Cell phone*, *Home address*, etc. would make sense for this folder type. If you don't use Windows Contacts, you can safely leave this folder type to use your Global settings.

**Library folder types**

Under each folder type listed above, there is a corresponding *Library* folder type. This controls the view you see when the folder is accessed via *Libraries*.

**OneDrive folder types**

Under each folder type listed above, except Contacts, there is a corresponding *OneDrive* folder type. This controls the view you see for folders on Microsoft OneDrive.

**Search Results folder types**

Under each folder type listed above, there is a corresponding *Search Results* folder type. This controls the view you see after doing a search. This is where a property, such as *Folder path* (or *File location*), is useful to show the path of any found item.

Note: Each of the folder type groups above (e.g. *Pictures*) is a family in WinSetView with the first member being the parent of the others. Therefore, for example, if you uncheck *Inherit* for the *Music* folder type and then edit its column headings, those settings will be inherited by all of the other *Music* folder types, as long as they have Inherit checked.

**Home / Quick access**

This folder type controls the view you see when clicking on the *Home* or *Quick access* item in Explorer's left navigation pane. This folder type is also known as the *Home Folder*.

**User Files**

This folder type controls the view you see for your user folder (e.g. C:\\Users\\SomeUser).

**User Files Search Results**

This folder type controls the view of results you see when you *search* your user folder.

**Searches**

This folder type controls the view you see for the *Searches* item within your user folder.


### Folder View Options

![image](https://github.com/user-attachments/assets/7352431f-0dcc-43a3-9dc3-9ae1deb60503)

Clicking the 🔍 button detects your current system settings (except for the "This PC" view). Otherwise, this page shows the settings that will be applied when you click **Submit**.

#### Show paths in search results only

When this option is checked, path and folder name column headings in Details view are only shown in search results. Such headings are shown in *blue* within WinSetView. The following column headings are affected by this setting:

**Folder path** or **File location** (ItemFolderPathDisplay): Full path to the folder. Example: C:\Movies\Ghibli\
**Folder** (ItemFolderPathDisplayNarrow): Folder name followed by preceding path. Example: Ghibli (C:\Movies)\
**Path** (ItemPathDisplay): Full path to the file. Example: C:\Movies\Ghibli\Ponyo.mkv\
**Folder name** (ItemFolderNameDisplay): The folder name only. Example: Ghibli

Tip: Select your preferred search result path column first and then select other headings, such as Date modified and Size. That way, when you do a search, the path of all matches will be visible without having to make the window larger.

Note: The path column will not appear when you search the Downloads folder because the Downloads folder type does not have an associated search results folder type.

Note: The *Relevance* column heading (*Search.Rank* property) is *only* shown in search results and is therefore always blue in WinSetView, regardless of this setting.


#### Windows XP/Vista view mode

This option was labeled "Legacy row and icon spacing" in previous WinSetView versions. When this option is enabled, Explorer will use the Windows XP/Vista style view mode. In this mode, rows in List and Details views are closer together, icon row spacing is not affected by long filenames, file names in icon views only wrap on certain characters (such as spaces and hyphens), and selected files in Explorer remain selected after changing the sort order.

Also, when this option is enabled, you can freely rearrange files and folders in Details and Icon views, but those arrangements will be forgotten when the folder is closed, unless you are running Windows 7, Windows 8.x, or a Windows 10 build that is lower than 1703.

Tiles and Content view behave in odd ways when this option is enabled. You may see one view upon setting the view and then a different view after closing and re-opening the folder. Content view did not exist in XP/Vista and the Tile mode was different than the modern Tiles view, so the odd results are expected.

**Note**: The Windows XP/Vista view mode does not apply to file open/save dialogs. If "Use General Items view for connected devices" is checked, you may see the XP/Vista view upon first touch of a folder in a file dialog, but the next visit to that folder, via a file dialog, will use the modern view.

**Note**: When Explorer is set to use this mode, it uses the system setting for the text color. That's not a problem if you are using light colors in Windows. However, if you switch to dark mode with this option enabled, you will get black text on a dark background. You can change the system text color, but be warned that change will be system-wide. There is no registry setting to change the text color exclusively for Explorer. Setting a system text color that can be seen on both light and dark backgrounds is one workaround. Another option is to install the program [QTTabBar](http://qttabbar.wikidot.com/) (select the "beta" download). QTTabBar will automatically change Explorer's text to white when dark mode is enabled.


#### Disable full row select

This option is available only when **Windows XP/Vista view mode** is checked.

When this option is checked, only the file name is highlighted in Details view, instead of the whole row.


#### Auto arrange

This option is available only when **Windows XP/Vista view mode** is checked.

Check or uncheck to set the default state for Auto arrange.


#### Align to grid

This option is available only when **Windows XP/Vista view mode** is checked.

Check or uncheck to set the default state for Align to grid.


#### System text color

This option is available only when **Windows XP/Vista view mode** is checked.

Click this button to change the system text color. There is no need to change the color if you are using the default light mode. If you are using dark mode, with Windows XP/Vista view mode, you may need to change the text color to something lighter so it's readable. Don't change the text to white because there are places in the system, such as the "Programs and Features" control panel item, where you will end up with white text on a white background. Do not use this option if you are using the app QTTabBar as it will take care of the text color for you.

Sample text, showing the current text color on both light and dark backgrounds, is shown beside the button. The sample text is actually the currently selected RGB color values (e.g. 0 0 0 = black).

The change to the system text color takes effect on next logout/login (or next restart).


#### Use General Items view for connected devices

Connected devices, such as phones and tablets, normally open in **Tiles** view with no option to easily change the view. The **Apply to folders** option is grayed out (or available but does nothing) for such devices, requiring view changes to be done folder by folder. Enabling the **Use General Items view for connected devices** option causes such devices to open in the same view that has been set for **General Items**.

Please note that this option causes all virtual folders, that share the General Items GUID, such as **Devices and Printers** and **Fonts**, to be displayed with the same view as **General Items**. So, for example, if you enable this option and have your **General Items** view set to **Details**, those other special folders will also be displayed in Details view.

WinSetView provides an option to set a specific view for **This PC** so that it's not affected by this setting. Unfortunately, it's not practical to provide options to set specific views for all special folders, that share the General Items GUID, as they cannot be set discreetly (i.e. it requires capturing many permutations of binary settings).

This option is set to *unchecked* by default since the change in view for folders such as **Fonts** would catch some users by surprise.


#### Use General Items column settings for connected devices

This option appears when **Use General Items view for connected devices** is checked.

When this option is checked, the column settings for the **General Items** folder type are propagated to special folder views, such as phones and tablets. This includes the selected columns, their arrangement, column widths, and sort and group by settings.

**Note**: Only the columns that are both common to **General Items** folders and the special folder will be displayed. For example, columns such as **Size**, **Modified date**, and **Type** will be shown in the phone or tablet view, but a column such as **Tags** (which is not typically available for a phone or tablet) will not be shown.

**Note**: When this option is enabled, you will briefly see an Explorer window open and close when WinSetView is applying your preferences. This is necessary for WinSetView to capture the General Items view settings in the binary format required for this option.

**WARNING**: This setting also applies to all special folders that share the General items GUID, such as the **Fonts** folder. Folders that have their own GUID, such as **Recycle Bin** and **Programs and Features**, will not be affected unless **Make All Folders Generic** is also checked. Therefore, it is NOT recommended to enable both this feature and **Make All Folders Generic**.


#### Make All Folders Generic

This option sets a registry value that tells Explorer to make all folders to be type *Generic* (i.e. *General Items*).

This makes the **Documents**, **Music**, **Pictures**, and **Videos** folders generic. Those folders will retain their special icons, but they will otherwise be generic (e.g. column headings in Details view will be the same as *General Items*). This option has no effect on the **Downloads** folder.

Please note that, even with this setting enabled, you can still change any folders to type **Documents**, **Music**, **Pictures**, or **Videos** using Explorer's **Customize this folder...** option. Any default views, you may have set for these folder types in WinSetView, would then apply.

Checking this option also causes **Folder Type Discovery** to be disabled. That's the windows feature that automatically changes a folder's type based on its contents. If you want your folder views to change with content, don't check this item. If you want a consistent view across all folders, regardless of content, you *may* want to check this option.

Please note there is no separate setting for **Folder Type Discovery**. If you want Folder Type Discovery *off*, you must make all folders generic. However, as noted above, you can change any folder (or tree of folders) back to a specific folder type at any time.

**Note**: Enabling this option will make the Home / Quick access view the same as "General items" if you're running the Windows 10 Explorer or the pre-App SDK Explorer in Windows 11. For the App SDK Explorer in Windows 11 (i.e. the latest Explorer), it will cause the Home view to lose its headings (i.e. it will not be grouped). Therefore, the WinSetVow option "Do not force standard grouping on Home / Quick Access" has no effect when "Make All Folders Generic" is enabled.

**WARNING**: It is NOT recommended to enable both this feature and **Use General Items column settings for connected devices**. See warning under that feature for details.


#### Do not force standard grouping on Home / Quick Access

When this option is unchecked (default), Home / Quick Access will be grouped by "Group". That is, the folder will have headings for pinned items, recent files, and recent folders.

When this option is checked, Home / Quick Access will be grouped by whatever you set, including (None).


#### Do not force standard grouping on Libraries

When this option is unchecked (default), Libraries will be grouped by "By Location". That is, you will get the default two-line header that shows the folder name and path.

**Note**: This was always possible by setting "Group by" for each library to "By Location". That step is no longer required.

When this option is checked, Libraries will be grouped by whatever you set, including (None).


#### Disable folder thumbnails

This option sets a registry value that tells Explorer to NOT create a thumbnail icon for *folders*. It has no effect on thumbnails for *files*.


#### Set view for "This PC"

If this option is checked, *This PC* will be set to the view selected.

If this option is unchecked, this virtual folder will retain its Windows default of *Tiles* and group by *Type*, unless **Use General Items view for connected devices** is selected, in which case, "This PC" will be in General Items view.

**Note**: Because **This PC** does not have its own GUID, this option creates registry values (in the BagMRU/Bags keys) that would be the same as if you manually browsed to this folder and set the view. These settings are prone to returning to Windows defaults (see *Apply to Folders "Bug"* below).


### Explorer Options

![image](https://github.com/user-attachments/assets/798a3d6f-ec22-412c-a7f6-0c7c4d10d24e)

![image](https://github.com/LesFerch/WinSetView/assets/79026235/31d5617f-6617-4e14-9b8e-0efb2c2b9896) **Note**: All options, except those with a shield icon, can be changed by a Standard user. The items with the shield icon require Administrator rights to change. A UAC prompt will appear after clicking **Submit** and **OK** if one or more of those options are being changed.

Clicking the 🔍 button detects your current system settings. Otherwise, this page shows the settings that will be applied when you click **Submit**.

#### Show File Extensions

By default, Windows hides file extensions for known file types. This is generally considered a bad idea for both usability and security (search the topic on the Internet for more details). Show File Extensions is checked by default in WinSetView.


#### Enable compact view in Windows 11

By default, Windows 11 spreads out items in list, details, and small icons views. This makes it easier to select items using a touch interface, at the expense of less information in the same space. Enabling *compact view* sets the spacing back to the tighter spacing used in Windows 10.


#### Show Hidden Files and Folders

When checked, hidden files and folders will be displayed in Explorer. This option affects the Explorer "Hidden files and folders" setting. It has no effect on the "Hide protected operating system files" setting.


#### Classic context menu in Windows 11

When checked, the registry setting that restores the Windows 10 style context (right-click) menu will be applied.


#### Enable Copy/Move To folder in the context menu

When checked, the items "Copy To folder..." and "Move To folder..." are enabled in the classic context menu.


#### No Internet in Windows search

When checked, the registry setting that makes Windows search local only (i.e. no Internet results) will be applied.


#### Disable search highlights

When checked, the registry settings that turns off search highlights will be applied.


#### Unhide the AppData folder

When checked, the hidden attribute is removed from the current user's AppData folder. Unchecking the option re-applies the hidden attribute.


#### Disable suggestion notices

When checked, the following "suggestion" notifications (found in "Notifications & Actions") will be turned off.

![image](https://github.com/LesFerch/WinSetView/assets/79026235/4c147f26-d570-470d-bc29-61d5972a1779)


#### Use Windows 10 Explorer on Windows 11

When checked, a registry setting will be applied that will cause Windows 11 to use the Windows 10 Explorer as its default file manager. That's the Explorer that has the ribbon interface and is normally only used in Windows 11 for the Control Panel. The feature "Also apply this template to all subfolders" works in this Explorer version.

![image](https://github.com/LesFerch/WinSetView/assets/79026235/2aef729f-38ad-469c-b6d7-de796800992a)

#### Remove Home in Windows 11

When checked, `Home` will be removed from the Navigation pane. When unchecked, `Home` is restored.

#### Remove Gallery in Windows 11

When checked, `Gallery` will be removed from the Navigation pane. When unchecked, `Gallery` is restored.

#### Disable numerical sort ![image](https://github.com/LesFerch/WinSetView/assets/79026235/31d5617f-6617-4e14-9b8e-0efb2c2b9896)

When unchecked, files are sorted numerically where possible. When checked, files are sorted only by their ASCII values. For example:

**With numerical sort enabled (Windows default)**:

*Example 1*

1.doc\
2.doc\
10.doc\
50.doc\
100.doc

*Example 2*

0F.doc\
2A.doc\
03.doc\
3A.doc\
20.doc

**With numerical sort disabled**:

*Example 1*

1.doc\
10.doc\
100.doc\
2.doc\
50.doc

*Example 2*

03.doc\
0F.doc\
20.doc\
2A.doc\
3A.doc

As you can see from the examples above, which setting is best depends on how you are naming your files. In general, everything works out better if you disable numerical sort and always pad numbered file names with leading zeros.

Why this option, which should be available to any user to toggle as needed, is locked down as a policy that requires Administrator rights to change, is one of the many mysteries of Windows design.

**Note**: If you've set a secondary sort property, name sorting will use the numeric ordering. Clear the secondary sort to allow non-numeric sorting. You can clear the secondary sort for the current folder simply by clicking the column header of another property such as Date modified. In WinSetView be sure to only set **Sort 1** to ensure you can use non-numeric sorting.

#### Enable feature 18755234 (Windows 10 Search) ![image](https://github.com/LesFerch/WinSetView/assets/79026235/31d5617f-6617-4e14-9b8e-0efb2c2b9896)

In late 2023, Microsoft pushed out an "update" that reverted Windows 10 back to the "classic" search of Windows 10 build 1903 and earlier. If you like the classic search, then you can leave this option alone. If you prefer the "new" search that Windows 10 had from 2019 to 2023, check this box to enable that feature.

This option has no effect on Windows 11.


#### Enable Classic Search in Windows 10

This option is only available when feature 18755234 is enabled. Once feature 18755234 is enabled, you can use this option to toggle between the "new" search and the "classic" search. You can use this option to enable "classic" search but keep the taller address / search bar of "new" search.

**Note**: "Classic" search includes results as you type and **Date modified:** calendar and **Size:** category pop-ups. "New" search waits for you to press **Enter** and displays a significant history dropdown list.


#### Disable feature 40729001 (Windows 11 Explorer) ![image](https://github.com/LesFerch/WinSetView/assets/79026235/31d5617f-6617-4e14-9b8e-0efb2c2b9896)

As of Windows 11 22H2 build revision 3085 (KB5034204) this option no longer has any effect and will only be shown if you are running an older build. If you are running an older build, this option disables the new App SDK Explorer.


#### Fix Desktop place in legacy dialogs ![image](https://github.com/LesFerch/WinSetView/assets/79026235/31d5617f-6617-4e14-9b8e-0efb2c2b9896)

Legacy file open/save dialogs, that are still used in some programs, such as IrfanView, Audacity, and RegEdit, show redundant items when you click the "Desktop" icon in the left panel. It's particularly cluttered in Windows 11. This registry setting causes the "Desktop" icon to only display files and folders that you have placed on the Desktop.

Before:\
![image](https://github.com/LesFerch/WinSetView/assets/79026235/8cc5416a-60b7-4bf7-a2a2-f22e1019c347)

After:\
![image](https://github.com/LesFerch/WinSetView/assets/79026235/5097e2a5-7502-4da5-a2d1-a0f0352ba143)

**Note**: With this option enabled on Windows 10, and older Windows 11 builds, the legacy dialog "Quick Access" item will change to "Frequent folders", but will show the same items.


### Unhide the Public Desktop folder ![image](https://github.com/LesFerch/WinSetView/assets/79026235/31d5617f-6617-4e14-9b8e-0efb2c2b9896)

When checked, the hidden attribute is removed from the Public Desktop folder. Unchecking the option re-applies the hidden attribute.


#### Set a start folder for Explorer

This option allows you to set the start folder for Explorer to "This PC", "Home / Quick Access", "Downloads", or any path you choose. This option works on Windows 10 and Windows 11. It does not work on Windows 7.

**Note**: The options "This PC" and "Home / Quick Access" are exactly the same setting you see in Folder Options beside "Open File Explorer to". The "Downloads" option is a minor variation of that setting and will result in a blank beside "Open File Explorer to". Setting any other path using the "Other" option creates a totally different registry entry that uses the "DelegateExecute" feature. That setting is known to not work with the WindHawk "Classic navigation bar" mod.

![image](https://github.com/LesFerch/WinSetView/assets/79026235/f2090713-8df1-45d1-a358-fb4a08af9a0b)


### Columns

![image](https://github.com/user-attachments/assets/c73b618c-1fb7-4907-966c-18cb564e012f)

Clicking the **Columns** button brings up the column (properties) selection page for the current folder type. Column headings, in Explorer Details view, correspond to file and folder *properties*.

The items displayed include all system properties that exist on all Windows computers.

The seven [Icaros](https://github.com/Xanashi/Icaros) media properties will be shown at the end of the list if the Icaros property handler is installed (which may come via a "codec pack"). The Icaros properties will be shown in the current language if a translation exists, otherwise English will be shown.

These System and Icaros properties are read from files in the **Languages** folder.

All remaining shell properties, provided by third-party apps, are imported to the **Columns** list when WinSetView starts. These properties are labelled using the current system language. Changing the language in WinSetView will not change the display language of these additional properties.

The top left of the page includes the same **Help** and **Re-center** buttons that are found on the main page. This is followed by the column re-order button **⮀** and then the name of the currently selected folder type (or *Global*). 

The top right of the page has a back button (🡨) that will take you back to the main page. Please note that clicking the **X** in the System menu bar will exit the application, just as it does on the main page.

Next, the currently selected column headings, that will display in File Explorer's Details view, are shown on a single, scrollable line in the same *order* as they will appear in File Explorer.

Clicking the column re-order button **⮀** will bring up a dialog that will allow you to rearrange the column headings by dragging them up or down in the presented list:

![image](https://github.com/user-attachments/assets/a1909c09-0985-4da2-99b0-9870e93b22ad)

The column order can also be set by removing each column heading and then adding them back in the desired order, but it is easier to use the re-order dialog. Note that the re-order dialog will allow any order, but will display the following warning if the **Name** property is not the first column:

![image](https://github.com/user-attachments/assets/7bf07a48-a1c0-48fc-8dc4-e234afead769)

The issue with software that uses the "legacy" type dialogs (such as IrfanView) is that those type of dialogs assume that **Name** is always the first column. So, for example, if **Size** is set as the first column, and you are in any view other than **Details**, you will just see a bunch of icons with sizes and no names.

Below the column heading line is a scrollable table that includes all of the Details view column headings that can be selected in Explorer (over 300 on Windows 10 and 11). These items are shown in the language of your choice, exactly as they appear in Explorer. Hovering the mouse over any name will show its internal Windows property name.¹

The top row of the table consists of a fixed row of buttons for selecting **Group by**, **Sort by**, **Width**, **Display**, and **Right-click** options. Hovering the mouse over any heading button reveals the button's description. The function of each of these buttons is described below.

¹ For those running WinSetView in a language other than English, the property name may appear to be showing the "English translation", but that's not correct. The property names are *fixed* internal Windows values and are not necessarily a direct match to the display name. For example, the property *ItemFolderPathDisplayNarrow* is shown in Explorer Details view as *Folder* in English or *Ordner* in German. The display names can also vary from one release to another. For example, the property *Search.Rank* is shown as *Search ranking* in Windows 7 and *Relevance* in Windows 10.

\
**(⮬) (Group by)**

This column will be disabled by default and the button at the top of the column will appear as an **X**. In this mode, no property is selected for grouping (i.e. *Group by* = *None*). To enable the column, click the **X**. The button will switch to **(⮬)** (for group by ascending) and a column of radio buttons will appear. Select the radio button beside the property you wish to group by. Only one property can be selected. Clicking the heading button again will switch to **(⮯)** (for group by descending). Clicking the heading button once more will hide the radio buttons and set grouping to none.

\
**⮬ (Sort 1, Sort 2, Sort 3)**

There are three Sort columns to allow sorting Explorer file/folder views on up to three different properties. Click a Sort column heading button to cycle between *ascending* (**⮬**), *descending* (**⮯**), or *disabled* (**X**). The first Sort column cannot be disabled. That is, at least one property must be selected for sorting. By default, *Sort by* is set to the Name (ItemNameDisplay) property in *ascending* order.

With a Sort column enabled (ascending or descending), click a radio button beside the property you wish to sort by.

**Note**: Sort 2 and Sort 3 are used to create a multi-level sort. If Sort 1 is set to something unique, such as Name, there is no point in setting a Sort 2 or Sort 3 (with one exception noted below). If Sort 1 is set to something non-unique, such as Type, then Sort 2 could be set to something else, such as Date modified or Name to create a two-level sort. A three level sort could be set up for Music folders with something like Artist for Sort 1, Album for Sort 2, and Title for Sort 3.

**Note**: In Explorer, you can force folders to always be a the top by setting the secondary sort to Type and then setting the primary sort to Name. You can do the same thing in WinSetview with Sort 1 and Sort 2. You can even get the same effect by setting both Sort 1 and Sort 2 to use Name. For Sort 2, it does not matter if you choose ascending or descending. But also note that setting a secondary sort will make sorting by name always use the numeric sort order. If you have checked **Disable numerical sort**, be sure that you only set **Sort 1** (Sort 2 and 3 should not be enabled).

**Note**: Prior to WinSetView 2.76 there were four Sort columns, but it has been determined that Windows only supports up to 3 sort levels via the FolderTypes registry key (that's used to set the default folder views) even though it's possible to set four sort levels via the File Explorer GUI by Shift-clicking column headings.

\
**⟷ (Column Width)**

This column allows you to set the default width for each property (column heading). For example, you can use this setting to make the Name column wider than the default of 34 ems.

The value is specified in ems. 1 em ≈ 1 char\
The equivalent number of pixels for 1 Em depends on the screen scaling. For example:\
1 em at 100% = 8 pixels\
1 em at 125% = 10 pixels\
1 em at 150% = 12 pixels\
Explorer uses ems internally for all its default column widths. This keeps the amount of text displayed in each column constant as screen scaling is changed.

Please note that you can set the width as small as 1em, but Explorer will expand the column width to its minimum allowed value when you drag the column width control in Explorer Details view. The minimum value cannot be overridden.

If you wish to enter the column width in *pixels*, hold **Alt** and **click** the input width field you wish to adjust. A dialog will open showing the width in pixels:

![image](https://github.com/user-attachments/assets/e38cbdd5-cd64-4361-a446-30fdd15fee59)

The pixel value will vary depending on screen pixel density, whereas the value in ems will be constant across different display configurations. Please note that WinSetView sets the column *default* width which can only be set to whole (integer) em values. Windows File Explorer lets you set the width down to the pixel, but that is stored as a setting within the volatile *Bags* registry key *overriding* the default value. WinSetView deals with *default* settings only.

If you click the **⟷** column heading button, it will prompt with an option to clear all column width fields.

\
**⋮⋮⋮ (Display in Details View)**

This column provides checkboxes to allow you to select which column headings are displayed in Details view. Any column selected for Details view also becomes a quick-pick item when you right-click in the column heading bar in Explorer. Therefore, when you select an item in this column, it also checks the item in the *Add to Right-Click Menu* column.

If you *uncheck* an item in this column, it does not uncheck the item in the *Add to Right-Click Menu* column because an item can be available for quick-pick without being an active column heading.

**Note**: Explorer does not allow you to remove the **Name** column, so the same is true in WinSetView by _default_. However, you can hold down the **Alt** or **Ctrl** key while clicking either the **⋮⋮⋮** or **⋮** button to enable the ability to uncheck the Name column. This would only make sense to do in scenarios where the folder type (e.g. "Music") contains files that have another unique identifier, such as "Title", and that identifier is set as the first column instead of Name.

\
**Column Order**: The *order* in which the selected columns are displayed in File Explorer is shown at the top of the screen. Click the **⮀** re-order button to change the order. The order can also be changed by unchecking each item and then rechecking them in the desired order.

Click the **⋮⋮⋮** column heading to quickly uncheck *all* selected column headings.

\
**⋮ (Add to Right-Click Menu)**

This column provides checkboxes to allow you to select which column headings are available for quick-pick when you right-click in the column heading bar in Explorer Details view.

The Explorer limit for the quick-pick menu is 21 items, so WinSetView will not allow you to select more than 21 items in this column. If you hit this limit, you will see this message:

![image](https://github.com/user-attachments/assets/6e6477ca-81a2-4e37-9cb6-3bbad60cfeb5)

Close the message and adjust your selections as necessary. You can't pick more than 21.

If you click the **⋮** column heading button, it will prompt with an option to clear all selections in the column. This will clear all selections that are NOT also selected in the *Display in Details View* column. Hold down the **Alt**, key when clicking **OK**, to completely clear both columns (except for the **Name** property).

### Column Headings (Properties)

There are over 300 different file/folder properties available to select in Explorer Details view. These same properties are available to select in WinSetView. Please note that the display name for each property is shown in WinSetView exactly as it appears in Explorer. Some of these names are ambiguous. For example, the name *Status* appears three times. In the *Columns* page, you can move the mouse over any display name to see its internal property name, but often that still doesn't help explain it. For example, what exactly does *Link status* display? Some of the less obvious properties are related to certain Office applications, but some are a complete mystery. Just use the ones that work for you and ignore the rest.

In addition to the path-related properties explained earlier, here are explanations of some other common properties:

**Date Modified**: The last date/time the file was updated on this file system.\
**Date Created**: This is the date/time the file was initially written to storage.\
**Date accessed**: Date file was last opened (rarely accurate due to deferred updates).

**Size**: The file size in KB or MB or GB\
**Attributes**: File attributes such as Archive[A], Hidden[H], System[S], Read-only[R]\
**File Version**: Applicable to files that have a version header, such as .exe files\
**Owner**: File owner in computer\userid format

**Item type**: The file's type based on file extension. Example: MPEG Layer 3\
**Type**: Usually same as Item type, but may show associated app name in search results.\
**Perceived type**: File category. Examples: Audio, Video\
**Kind**: Similar to Perceived type. Examples: Music, Video\
**Content type**: Essentially Perceived type + Item type. Example: audio/mpeg\
**File extension**: Example: .mp3 (handy for sorting if you don't need a type field)

Note: The **File extension** column heading is not available on Windows 7.

### Search

Press **Ctrl-F** to search for text within any page. This is most useful for finding properties in the **Columns** page. Please note that this function is provided by the MSHTML engine. There is no specific code in WinSetView for the search function, so it cannot be modified or enhanced in any way.

![image](https://github.com/user-attachments/assets/a16ebb3a-5228-4e64-9b02-a397155d2006)

## Files

In addition to the two main files: **WinSetView.exe** (HTML application), and **WinSetView.ps1** (PowerShell command line script) the following folders and files are included:

### AppData Folder

The **AppData** folder is dynamically created from the **Defaults** folder. If an **AppData** folder already exists, only missing files are copied from **Defaults**. This allows a new version of the WinSetView folder to be copied over an old version without risk of overwriting existing user's WinSetView settings.

This folder contains INI files which hold the options selected with the WinSetView interface. Due to the folder type and column heading (property) lists differing among Windows versions, there are separate INI files for Windows 7, 8, and 10. Windows 11 uses the same settings file as Windows 10.

This folder will also contain a *Backups* folder after first run containing REG files that can be used with the Restore option to rollback to a previous state of Explorer view settings.

For system administrators and power users, please note that the *WinSetView.ps1* script will accept one INI file or one REG file as a command line parameter. You can also pass INI files to WinSetView.ps1 using *WinSetView.vbs* (which may be moved from Tools to AppData).

Please note, for system administrators setting up *new* user profiles, it may be more efficient to capture the results of WinSetView to a REG file and apply that file using the command **reg import filename.reg** rather than running WinSetView for each new user. Two different scripts for capturing Explorer view settings to a REG file are provided in the Tools folder. See below for more details.

### AppParts Folder

This folder contains files that are used by *WinSetView.exe* or *WinSetView.ps1*.

**Fonts.txt** contains a list of fonts to display in the WinSetView font selection menu.

**Themes.ini** contains the WinSetView light and dark themes. This file can be edited to change the existing themes or add new themes.

**ViVeTool.exe** and **Albacore.ViVe.dll** are used to enable or disable certain Windows features shown in the Explorer Options page.

**GetMoreProperties.exe** is used by WinSetView.exe to retrieve the custom properties installed by third-party apps.

**CSReg.exe** replicates most of the functionality of Reg.exe. It's used by WinSetView.ps1 on systems that do not have Reg.exe or block Reg.exe with the DisableRegistryTools policy.

**CloseExplorerWindows.exe** is used by WinSetView.exe to close open Explorer windows without killing the Explorer task. This is used to capture the General Items folder view for the option "Use General Items column settings for connected devices".

### Language Folder

This folder must exist and contain the **en-US** folder and language files in order to run *WinSetView.exe*. All other language folders are optional. This folder is not needed for WinSetView.ps1.

### Tools Folder

This folder contains supplemental tools for system administrators and power users.

**WinSetBack.ps1**

PowerShell script for backing up and restoring all Explorer view related settings. System administrators can use WinSetBack.ps1, after running WinSetView and making any further manual view settings, to back up all view settings to a single REG file. The REG file can be applied to a *new* user account with a simple REG IMPORT command. This approach will not work for updating profiles that are already in use (unless it's combined with code to delete the user's Bags/BagMRU registry keys to clear the existing saved views).

**WinSetBack.cmd**

For those who prefer to go old school. This does the same thing as WinSetBack.ps1 except that it saves the backup to the desktop instead of the script's directory.

**CaptureCustom.js**

Whereas WinSetBack.ps1 captures ALL Explorer view-related keys, *CaptureCustom.js* captures only the *BagMRU*, *Bags*, and *Control Panel* keys to provide a supplemental file for use with WinSetView.

This script captures Explorer view settings that can't be set in WinSetView, such as *Recycle Bin* and *Control Panel* views. First run WinSetView to set your desired Explorer default view settings. Next, set Recycle Bin, Control Panel, etc. to your desired views and close those windows. Then run CaptureCustom.js. It will export the ControlPanel, BagMRU, and Bags keys to a file named WinSetViewCustom.reg.

Place WinSetViewCustom.reg in your active WinSetView AppData folder to have it applied by WinSetView. WinSetView.ps1 will import the file WinSetViewCustom.reg after all other settings are applied. This will override any settings applied by WinSetView!

Please, if you don't know what you're doing, avoid this level of customization!

**WinSetView.js**

A simple launcher for WinSetView.ps1 that may come in handy for system administrators.

## Command Line Operation

### Typical Usage

If you cannot run **WinSetView.exe** on your computer, for whatever reason (e.g. VBScript is disabled), but you can run **PowerShell** scripts, then you can run WinSetView on another computer (obviously one where WinSetView does run), select your view preferences, and save those preferences to an INI file (**Win10.ini** for Windows 10 and 11). The preferences are saved automatically when you click **Submit**, but can also be saved manually using the **Save Settings** button available with the **Advanced** interface.

Once you have an INI file (e.g. Win10.ini) with your preferred defaults, it can be deployed to any user via PowerShell. For example:

`.\WinSetView.ps1 .\AppData\Win10.ini`

If PowerShell script execution is not enabled, you can run the script using this command:

`PowerShell -ExecutionPolicy ByPass .\WinSetView.ps1 .\AppData\Win10.ini`

**Note**: If you wish to always enable script execution for the current user, the following command is generally recommended:

 `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
 
 You can replace `RemoteSigned` with `Unrestricted` or `Bypass` for less security. For more details see the this [page](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies).
 
### For System administrators

If you wish to apply the folder view default registry values generated by WinSetView to new user accounts, you can use the scripts described in the **Tools Folder** section to capture those registry values and then deploy them at first user logon via a simple **Reg.exe** command.

However, if you wish to apply the folder views defaults to not-new user profiles, applying the registry values alone will not work. The current Bags/BagMRU registry keys have to be deleted and Explorer restarted to get the new default views. In such cases, where you want to automate this procedure via the command line, follow the procedures described above under **Typical Usage**.

## Background

Folder views in Windows Explorer are both flexible and, sometimes, frustrating. Many users have reported their view settings getting inexplicitly reverted back to Windows defaults, especially as it concerns the *Downloads* folder. However, some of these frustrations may be due to a misunderstanding of how the views work.

In Explorer, there are separate views for each folder type and often multiple folders that point to the same physical location. See the *Downloads Folder* section below for more details on this topic. Understanding Explorer's **Apply to Folders**, **Reset Folders**, and **Customize this folder...** features is key to getting control over Explorer's folder views.

WinSetView makes it *much* easier to get the views you want in Explorer across all folders, but it's still useful to understand how to set the views using Explorer only.

### Apply to Folders

The **Apply to Folders** button can be found in **View**, **Options**, **Change folder and search options**, **View** tab. Many users interpret this button to mean "Apply to ALL folders". That's not what it means. It actually means "Apply to all folders that are the same type as the current folder".

This button can be used to set a consistent view for a given folder type, such as the *Pictures* or *Downloads* folder types. It does not, however, provide an option to set folders of different types to a single *global* view.

**Note**: The **Apply to Folders** button does NOT reset any file dialog views that have been previously opened. This is another reason to use WinSetView to reset views consistently.

### Reset Folders

The **Reset Folders** button can be found in the same place as the **Apply to Folders** button. It will reset all folders, that are the same type as the current folder, to Windows default views for that folder type.

If WinSetView was used to set the folder type default views, **Reset Folders** will revert the folder views to the settings you selected in WinSetView.

### Customize this folder...

The **Customize this folder...** menu item allows you to change the current folder (and optionally all of its subfolders) to one of the five major folder types. This can be used in any standard folder, but cannot be used in special folders, such as libraries.

To use this option, click in a folder's white space, select **Customize this folder...**, select the desired folder type, such as *Pictures*, from the menu, check **Also apply this template to all subfolders** (if you want the change to apply to subfolders), and then click **Apply**. This will change the folder's type and it will then be displayed using the view settings for that folder type.

**Note**: The option **Also apply this template to all subfolders** does not work in the Windows 11 Explorer since the KB5008353 update (build 22000.469) from January 25, 2022. For drive C (or any NTFS formatted drive of type "Local Disk") you can set the folder type for a whole tree using the [SetFolderType](https://lesferch.github.io/SetFolderType/) tool. Otherwise, you may want to consider enabling the option to use the Windows 10 Explorer on Windows 11.

### General Items (Generic) Folders

Without WinSetView, you can get closer to a global view by setting a generic folder, such as C:\\, to your desired views and then use the **Apply to Folders** button to set all other generic folders the same. But, by default, there are many folders that are not generic folders. To get even closer to a global view, you can set a registry value that will make most folders become generic (i.e. type *General items*). That registry value is:

    [HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell]
    "FolderType"="Generic"

Note:
* You can substitute *Generic* with *NotSpecified* and get the same result.
* WinSetView makes this registry entry for you (if desired). It's only shown here for educational purposes.

With the above registry value set, changing the view for a generic folder, such as C:\\, and then clicking the **Apply to Folders** button will also change the view for *Documents*, *Music*, *Pictures*, and *Videos* because they will all be *General items (Generic)* type folders.

Please note that the *Generic* registry setting has no affect on the *Downloads* folder. It will always remain its own unique folder type.

### Automatic Folder Type Discovery

By default, Explorer has automatic folder type discovery *enabled*. This means Explorer will automatically change a folder's type (and hence its view) based on its contents. The "FolderType"="Generic" registry entry, described above, also disables automatic folder type discovery. This setting is applied by WinSetView when you select the **Make All Folders Generic** option.

If you want the folders *Pictures*, *Videos*, etc. to have the same view as *General Items*, then it will make sense to check the **Make All Folders Generic** option in WinSetView. However, if you want different views for these folders, it's probably not worth the trouble to check *Make All Folders Generic* just to turn off automatic folder type discovery. See this topic in the **FAQ** section for more details.

### Downloads Folder

Many users have been frustrated by the default setting of the *Downloads* folder type that groups files by *Date Modified*. After finding the *Group by* setting and changing it to *(None)* they are frustrated to see the grouping "come back". In most cases, the *Group by* setting did *not* come back, but the user is simply looking at a different view of the Downloads folder. That's where the confusion about Explorer's folder type design comes into play.

It's logical to assume that if one sets the view for a folder it shouldn't matter how ones gets to that folder, but in Explorer it does. A different route to a folder will sometimes mean that you are actually opening a different "folder" (actually a namespace) that points to the same physical location. Since it's a different "folder", it has its own view. However, all of these different "folders" are of the same *folder type* so, you can use Explorer's **Apply to Folders** button to apply the change to (almost) all of them. The big exception is that **Apply to Folders** does NOT update file open / save dialog views, which is why it's better to use WinSetView to set the Downloads folder view.  

### Apply to Folders "Bug"

Whenever you use the **Apply to Folders** button, on any generic folder, such as C:\\, your views for **This PC** (and USB connected phones and possibly other virtual folders) will revert back to Windows *defaults*. If you always leave **This PC** (and other devices) at their default views, this is not an issue, but if you have changed the views and want to keep them changed, avoid using **Apply to Folders** on generic folders. Instead, use **WinSetView** if you want to change your General Items (generic) folder view settings.

## FAQ

### Does WinSetView show my current folder view settings?

No. It shows the view settings that have been configured in the currently loaded settings file (e.g. Win10.ini). The idea is that the app is portable (e.g. run from anywhere such as a flash drive, server, etc.) so that you can easily apply your preferred folder views to a new computer or new user or reapply your preferred views whenever necessary.

### Can you add a feature to read my current folder view settings?

No. Although this is "possible" in theory, it's impractical to implement as the data to be extracted is stored in a binary format that Microsoft has not publicly documented.

### Is there a way to load up Microsoft's default folder view settings (for Windows 10 and 11) into WinSetView?

Yes. Enable the **Advanced** interface, click **Load Settings**, and then select the file **Win10-Microsoft-Defaults.ini**.

### How is WinSetView better than Explorer's "Apply to Folders"?

That option only applies your changes to folders of the *same type*. Explorer has many folder types, (e.g. Downloads, Pictures, Search Results, etc.), requiring you to set your desired view options repeatedly and "Apply to Folders" does NOT reset the views for Open and Save dialogs. Additionally, many users encounter situations where their selected options, set using "Apply to Folders", are reverted back to Windows defaults for no obvious reason and sometimes "Apply to Folders" will simply refuse to make any changes.

### Does WinSetView require administrative privileges?

No (other than a few optional settings). WinSetView creates a copy of the Windows folder view defaults, edits that copy, and applies it to the current user. The changes do not affect other users and are only part of the current user's profile.

### Is there an Undo?

Yes, as described under *Restore* above, if **Backup** is checked, WinSetView creates a backup every run that can be restored at any time. You can also revert the Explorer views to Windows defaults at any time. However, be sure to check the **Explorer Options** screen and set those options as desired, as only some of those settings are captured in the backup.

### Can I disable automatic folder type discovery and keep special folder types, such as Pictures?

Yes, but it's not convenient and currently is only practical on Windows 10 (or Windows 11 configured to use the Windows 10 Explorer) because the option **Also apply this template to all subfolders** is broken in the Windows 11 Explorer.

Here are the steps:

Select your desired options in *WinSetView*, including all desired views for *Pictures*, *Videos*, etc.

Check the option **Make all folders generic** and then click **Submit**.

In *Explorer*, open your *Pictures* folder, click in the white space, select **Customize this folder...**, select *Pictures* from the menu, check **Also apply this template to all subfolders**, and click **Apply**. Repeat this step for any other folder trees that you wish to set as *Pictures*. Repeat, similarly, for *Documents*, *Music*, and *Videos* folder types.

If you run WinSetView again with *Make all folders generic* checked, you will have to do the *Customize this folder...* procedure again to get your custom views for Pictures (and other special folders) to reappear.

For most users, who want to keep special folders such as *Pictures*, it's simpler to leave automatic folder type discovery enabled, set up all the folder types with your preferred views in WinSetView, and use **Customize this folder...** for the occasional folder that switches to an undesired folder type.

### How does WinSetView work?

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

2) Delete those keys.

3) Set any direct registry entries, such as *Show File Extensions* and *Make All Folders Generic*, for the current user.

4) Copy FolderTypes key from HKEY_LOCAL_MACHINE (HKLM) to HKEY_CURRENT_USER (HKCU).

5) Edit FolderTypes key in HKCU per user's selections.

6) Depending on selected options, also create direct registry view entries for "This PC", "General Items", and "XP/Vista view mode".

7) Restart Explorer.

## Language Support

WinSetView is designed to work with any left to right language. There are currently 33 languages included with WinSetView. If your language is not included, please contact me.

I have not included any right to left languages, such as Arabic, with WinSetView, as I'm not sure if that would be useful. However, if a native speaker tells me it would still be helpful to have their right to left language included, I will certainly add the language.

### Language Files 

The **WinSetView.exe** script looks for a **Language** folder in the same location as the script. The Language folder contains one folder for each supported language (e.g. *en-US*). Within each language folder are the following files:

*Columns-Win11.txt\
Columns-Win10.txt\
Columns-Win7.txt\
Columns-Win8.txt\
FolderTypes.txt\
Font.txt\
Labels.txt\
ViewList.txt*

If you wish to edit an existing language, you only need to touch the files *Labels.txt* and *FolderTypes.txt*. The *Columns* and *ViewList* files contain language strings pulled directly from Windows, so they are already perfectly matched to what Explorer displays.

The *Font.txt* file contains the default display font for the language. 

If you edit *FolderTypes* and *ViewList* please be sure to use EXACTLY the same terms that Windows uses.

If you wish to create a new translation, please contact me and I will create all the files so you only have to edit the two machine translated files.

### Language Contributions 

Wherever possible, translated text is pulled directly from Windows (e.g. column headings). Some languages have had the benefit of human translation, but most have been done using online translation software and could use improvement from a native speaker. If you can help with a translation, please contact me!

Please see the Acknowledgment section for any language files that have been hand-corrected.

Please refer to the *en-US* folder when creating or editing a translation.

Save all edited language files as type **Unicode (UTF-16)**.

## Acknowledgements

Thanks to **Jean-Hervé Lescop** of Adersoft for updates to VbsEdit to accommodate WinSetView.

Thanks to **Keith Miller** at TenForums.com for documenting the FolderTypes approach to setting default views.

Thanks to **Patrick Hannemann** for the initial German (de-DE) translation.

Thanks to **Ringo Xue** for the initial Simplified Chinese (zh-CN) translation.

Thanks to my daughter **Dana** for the Japanese (ja-JP) translation.

Thanks to my son **Brian** for HTML/CSS help. If you use Spotify on Android, please check out his  [**Trimify**](https://play.google.com/store/apps/details?id=app.web.trimifymusic) app on the Google Play store.

Thanks to my cat **Puddles** (2009-2022) for keeping me company while I worked on this.

\
[![image](https://github.com/LesFerch/WinSetView/assets/79026235/63b7acbc-36ef-4578-b96a-d0b7ea0cba3a)](https://github.com/LesFerch/WinSetView)
