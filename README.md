# WinSetView

## Globally Set Explorer Folder Views

Compatible with Windows 7, Windows 8, and Windows 10.

Les Ferch, lesferch@gmail.com\
GitHub repository created 2021-03-26, last updated 2021-06-04

# Summary

This tool provides an easy way to globally set Windows Explorer folder views. For example, if you want Details view with a particular selection of column headings enabled across all folders, then this tool will do that for you.

The tool is comprised of two files: **WinSetView.hta** (HTML GUI with VBScript code) and **WinSetView.ps1** (Powershell command line script).

Double-click **WinSetView.hta** to open the GUI. When you click **Submit**, the hta/vbs script will pass your choices as parameters to WinSetView.ps1, which will make the changes and then restart Explorer.

Each option, and related Explorer background information, is detailed below, but if you just want to get to it, the dialog is pretty much self-explanatory. For best results, close all open applications before running this tool. Open applications can prevent open/save dialog views from being updated.

All changes made by this tool are per-user within the HKEY_CURRENT_USER hive in the registry. No machine settings are touched and no elevated privileges are required. On each run, the tool makes a unique backup file of the affected registry values. A restore option is provided allowing you to rollback to any of these backups. There's also an option to completely reset all Explorer views to Windows default values.

# Options
![image](https://user-images.githubusercontent.com/79026235/116888269-3f2c3400-abf9-11eb-8ca1-9f8e018f8631.png)

## Language Dropdown Menu

This allows you to select an interface language for WinSetView. See **Language Support** section below for details. This option does NOT change the Windows language.

## Reset Views to Windows Defaults

This option clears the registry keys that hold Explorer views and restarts Explorer, causing all folder views to revert to Windows defaults.

## View Radio Buttons:
For your global Explorer view, you can select one of:
**Details, List, Tiles, Content, Small Icons, Medium Icons, Large Icons**

Your selection will apply to all folders except "This PC" and "Network". 

## No Grouping

This option turns off grouping in all folder views. This is most often desired for the **Downloads** folder which has grouping by date enabled by default.

## Make All Folders Generic

This option disables "Folder Type Discovery". That's the windows feature that automatically changes a folder's view based on its contents. If you want your folder views to change with content, don't check this item. If you want a consistent view across all folders, regardless of content, check this option. This option also makes the **Documents**, **Music**, **Pictures**, and **Videos** folders generic. Those four folder will retain their special icons, but they will behave like a generic folder (i.e. column headings in Details view will be generic). This option has no effect on the **Downloads** folder.

## Keep "Apply to Folders" Views

This option retains any folder views that have been saved using Explorer's **Apply to Folders** button. This is a very effective method to have some customization in addition to a global view setting.

If you want this extra level of view customization, be sure to use the **Apply to Folders** button in Explorer for each folder type view you want to set. That is, in *Explorer*, set your desired view for **Downloads**, then go to **View**, **Options**, **Change folder and search options**, **View** tab, and click **Apply to Folders**. Repeat those steps for **Documents**, **Music**, **Pictures**, and **Videos**. All of those views will then take precedence over any global folder view set with *WinSetView*, as long as **Keep "Apply to Folders" Views** is *checked* and **Make All Folders Generic** is *unchecked*.

If **Make All Folders Generic** is also checked, only **Downloads**, **Libraries**, and **Search Results** will get their views from any view saved via Explorer's **Apply to Folders** button.

## Set Global Column Headings

Check this box if you want to control which column headings are enabled globally for Details view. Uncheck it if you want Windows default column headings. The column heading order is shown in the text box, using the heading names, as they are stored in the registry. To control the order, uncheck all column headings and then check them in the order you want them to appear left to right.

Seventeen of Explorer's column headings are provided (I can add more on request). There are many more heading choices in Explorer, but these are the ones that are most likely to be applicable globally. Some of them appear redundant, but they're all different in some way. Each heading is explained below:

## Path headings (useful in search results):

**Folder path**: Full path to the folder. Example: C:\Movies\Ghibli\
**Folder**: Folder name followed by preceding path. Example: Ghibli (C:\Movies)\
**Path**: Full path to the file. Example: C:\Movies\Ghibli\Ponyo.mkv\
**Folder name**: The folder name only. Example: Ghibli

In WinSetView 1.5 and above, the path columns will only appear in search results. Please note that the path column will not appear when you search the Downloads folder because the Downloads folder type does not have an associated search results folder type. Tip: Select your preferred search result path column first and then select other headings, such as Date modified and Size. That way, when you do a search, the path of all matches will be visible without having to make the window larger.

## Date headings:

**Date Modified**: The last date/time the file was updated on this file system.\
**Date Created**: This is the date/time the file was initially written to storage.\
**Date accessed**: Date file was last opened (rarely accurate due to deferred updates).

## General purpose headings:

**Size**: The file size in KB\
**Attributes**: File attributes such as Archive[A], Hidden[H], System[S], Read-only[R]\
**File Version**: Applicable to files that have a version header, such as .exe files\
**Owner**: File owner in computer\userid format

## File type headings:

**Item type**: The file's type based on file extension. Example: MPEG Layer 3\
**Type**: Usually same as File type, but may show associated app name in search results.\
**Perceived type**: File category. Examples: Audio, Video\
**Kind**: Similar to Perceived type. Examples: Music, Video\
**Content type**: Essentially Perceived type + Item type. Example: audio/mpeg\
**File extension**: Example: .mp3 (handy for sorting if you don't need a type field)

The **File extension** column heading is not available on Windows 7.

## Name and Path Column Widths
The first number sets the width of the name column (first column) in Details view. The second number Sets the width of any path columns enabled in Details view.\
The value is specified in ems. 1 em ≈ 1 char\
Em size is relative to screen scaling. For example (at 96 dpi):\
1 em at 100% = 8 pixels\
1 em at 125% = 10 pixels\
1 em at 150% = 12 pixels\
Explorer uses ems internally for all its default column widths. This keeps the amount of text displayed in each column constant as screen scaling is changed.

## Set views for "This PC" and "Network"

If this option is checked, the tool will set your chosen view settings for "This PC" and "Network". If the option is unchecked, these virtual folders will retain the Windows default of Tiles and group by category. Under this checkbox, you can select the desired view for "This PC" and "Network" and choose to disable or keep grouping.

## Submit

This button executes the Powershell script which will apply the selected options to the registry and restart Explorer. How it works this magic is explained further below.

## Last Run Settings

This button will be grayed out on first run. The next time you run the tool, your selected options from the previous run will load automatically. If you then make one or more changes to the selections, and want to get back to what you picked on last run, just click the Last Run Settings button.

## App Defaults

Clicking this button will return the interface to the default choices baked into the code.

## Restore from Backup

This button will be grayed out on first run. Each time you click Submit, the Powershell script makes a backup of the user's Explorer view registry keys to a date-time-named file. The Restore from Backup button will bring up a dialog to let you pick a backup file to restore. Since it's a standard Explorer dialog, you can use the same interface to delete any unwanted backups by selecting them and right-clicking to get a **Delete** option.

-----------------------------------------------------------------------------------

# Background

Folder views in Windows Explorer are both flexible and frustrating. Many users have reported their view settings getting inexplicitly reverted back to Windows defaults, especially as it concerns the Downloads folder. However, some of these frustrations may be due to a misunderstanding of how the views work.

## Explorer's Many Views

The Downloads folder, for example, has at least four different views. Those four views are: 1) This PC, Downloads, 2) C:\Users\Username\Downloads, 3) This PC, Downloads via an Open or Save dialog, and 4) C:\Users\Username\Downloads via an Open or Save dialog. Frequently, a user will set one of these views and then encounter one of the other views and get angry that their view settings "didn't stick".

## Apply to Folders Explained

Another confusion is over the **Apply to Folders** button. This can be found in **View**, **Options**, **Change folder and search options**, **View** tab. Many users interpret this button to mean "Apply to ALL folders". That's not what it means. It actually means "Apply to all folders that are the same type as the current folder". This button can be used to set all views of the **Downloads** folder the same, so it is very useful, but Explorer provides no option to set all folders and virtual folders to one *global* view.

Without WinSetView, you can get closer to a global view by setting a generic folder, such as C:\\, to your desired views and then use the **Apply to Folders** button to set all other generic folders the same. But, by default, there are many folders that are not generic folders. To get even closer to a global view, you can make the **Apply to Folders** button apply to more folders by setting a registry value that tells Explorer to treat "all folders" as "Generic". That registry value is:

    [HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell]
    "FolderType"="Generic"

Note: You can substitute "Generic" with "NotSpecified" and get the same result.

Note: This tool makes this registry entry for you (if desired). It is only shown here for educational purposes.

With that value set, changing the view for say, C:\\, and then clicking the **Apply to Folders** button will also change the view for Documents, Music, Pictures, and Videos, but not Downloads. Explorer really likes to keep the view for Downloads separate from all other folders.

## Apply to Folders "Bug"

Whenever you use the **Apply to Folders** button, on any generic folder, such as C:\\, your views for "This PC" and "Network" will revert back to Windows defaults. If you always leave "This PC" and "Network" at their default views, this is not an issue, but if you have changed either view and want to keep it changed, this is a nuisance.

There is a workaround. Any folder that is open when **Apply to Folders** is used, will not have it's view changed. So, to "protect" your custom views for "This PC" and "Network", be sure to have separate windows open to each of those views when you use the **Apply to Folders** button.

## Automatic Folder Type Discovery

By default, Explorer has automatic folder type discovery enabled. This means Explorer will automatically change the view of a folder based on its contents. People generally love or hate this feature. If you're reading this, you probably fall into the latter camp. The same "FolderType"="Generic" registry entry, described above, also disables automatic folder discovery. This option is applied by the tool when you select the **Make All Folders Generic** option.

-----------------------------------------------------------------------------------

# FAQ

## How is this better than Explorer's "Apply to Folders"?

That option only applies your changes to folders of the *same type*. Explorer has many folder types, (e.g. Downloads, Pictures, Search Results, etc.), requiring you to set your desired view options repeatedly. Additionally, many users encounter situations where their selected options are reverted back to Windows defaults for no obvious reason. This tool allows you to make quick *global* changes to your view settings that will not unexpectedly change.

## Can I use Explorer's "Apply to Folders" option in combination with this tool?

Yes. See the section above that describes the **Keep "Apply to Folders" Views** feature.

## Does this tool require administrative privileges?

No. This tool creates a copy of the Windows folder view defaults, edits that copy, and applies it to the current user. The changes do not affect other users and are only part of the current user's profile.

## Is there an Undo?

Yes, as described under "Restore from Backup" above, the tool creates a backup every run that can be restored at any time. You can also revert the Explorer views to Windows defaults at any time.

## How can I have a folder path column only in Search Results?

Use WinSetView 1.5 or higher. In WinSetView 1.5 and above, the path columns are only applied to search results. See the path headings section above for more details.

## How can I disable automatic folder type discovery and keep special folder views, such as Pictures?

Select your desired options in *WinSetView*, check the option **Make all folders generic** and then click **Submit**. Then, in *Explorer*, open your **Pictures** folder, click in the white space, select **Customize this folder...**, Select **Pictures** from the drop down menu, check **Also apply this template to all subfolders**, and click **Apply**. Repeat this step for any other folder trees that you wish to set as Pictures. Repeat, similarly, for **Documents**, **Music**, and **Videos** folder types.

Once you've set up these special folder types, be sure to use the **Apply to folders** button any time you change a view that you want applied to all folders of the same type.

If you run WinSetView again with **Make all folders generic** checked, be sure to check the option **Keep "Apply to Folders" Views**. Then, you will only have to do the **Customize this folder...** procedure to get your custom views for **Pictures** (and other special folders) to reappear. If you uncheck **Make all folders generic** and check the option **Keep "Apply to Folders" Views**, then you won't have to repeat the **Customize this folder...** procedure, but automtic folder type discovery will be re-enabled.

## How does this tool work?

To answer that question, let's first look at how Explorer selects the views for your folders...

When a folder is opened, Explorer looks for existing view settings in the BagMRU/Bags keys:

    HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU
    HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags

If no settings exist there, it then checks the Streams\Defaults key for any default settings that have been applied using the **Apply to Folders** button:

    HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults

If the view settings are not in the Streams\Defaults key, it checks the FolderTypes key in HKEY_LOCAL_MACHINE for the default view settings for the folder type that was just opened and applies those settings:

    HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes

Explorer then saves the settings in an entry in the user's BagMRU/Bags keys that will be updated whenever the user changes the view for that folder.

Fortunately for us, Explorer will also look for the FolderTypes key in HKEY_CURRENT_USER and, if it exists, use that instead of the one in HKLM:

    HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes

This provides an opportunity to set our desired default settings without touching the base defaults for the machine and all other users (and not requiring admin privileges).

Note: Default views for all folders except "This PC" and "Network" can be found in the FolderTypes key.

**How This Tool Works**:

Here's an overview of the steps the Powershell script performs to set Explorer views as per the selected options:

1) Backup the existing user's registry keys that hold Explorer views
2) Delete those keys (except Streams/Defaults if Keep "Apply to Folders" Views is checked).
3) Set any direct registry entries, such as Show File Extensions and Make All Folders Generic, for the current user.
4) If custom "This PC" and "Network" views have been selected, create BagMRU/Bags entries for those views.
5) Copy FolderTypes key from HKEY_LOCAL_MACHINE (HKLM) to HKEY_CURRENT_USER (HKCU).
6) Edit FolderTypes key in HKCU per user's selections.
7) Restart Explorer.

-----------------------------------------------------------------------------------

# Language Support

The **WinSetView.HTA** script looks for a **Language** folder in the same location as the HTA. If none is found, it will display English using text built into the script. If it finds a language folder, it will read the list of **.txt** files found there to create a language dropdown menu. Several example language files are included. The file **English.txt** should be used as a template to create a new language file.

Contributors are needed to correct the sample language files (other than English) since most of the text was translated from English using Google Translate. The folder view radio buttons and the column heading checkbox labels are already correct in the samples because those were copied from Windows running in those languages. The other labels, buttons, and help text probably have many errors. If you can help correct a language file or add a new one, that would be most appreciated. I look forward to seeing some Asian language files as well.

Please see the Acknowledgment section for any language files that have been hand-corrected.

## Language Template 

The first line in the file specifies the title displayed in the dialog title bar.

The next set of lines represent the radio button and checkbox labels, one per line with no blank lines. Please note that the second row of radio buttons in the dialog are not included in the language file because they have the same labels as the first row.

This is followed by a **<>** separator and the title for the **Help** dialog and then another **<>** separator followed by the Help dialog text.

Save the text file as type **Unicode (UTF-16)**. The file can have any name as long as it has a **.txt** extension, but it makes sense to give the file a name that matches its language selection in Windows. For example: **Deutsch (Deutschland).txt**


# Acknowledgements

Thanks to **Keith Miller** at TenForums.com for providing the FolderTypes approach to setting default views.

Thanks to my son **Brian** for helping me debug and clean up my HTML code. If you use Spotify on Android, please check out his [**Trimify**](https://play.google.com/store/apps/details?id=app.web.trimifymusic) app on the Google Play store.

Thanks to **Patrick Hannemann** for providing the **Deutsch (Deutschland)** (German) language file.

Thanks to **Vladimir Bondarev** for providing the **Pусский** (Russian) language file.

Thanks to **Ringo Xue** for providing the **中文 (简体)** (Simplified Chinese) language file.

Thanks to **Danfong Hsieh** for providing the **中文 (繁體)** (Traditional Chinese) language file.

Thanks to my daughter **Dana** for providing the **日本語** (Japanese) language file. The translation may be rough in places, as she is very new to the language. Please gently provide corrections. Thank you.

Thanks to my cat **Puddles** for keeping me company while I worked on this.
