# WinSetView

## Globally Set Explorer Folder Views

Les Ferch, lesferch@gmail.com, GitHub repository created 2021-03-26

# Summary

This tool provides an easy way to globally set Windows Explorer folder views. For example, if you want Details view with a particular selection of column headings enabled across all folders, then this tool will do that for you.

The tool is comprised of two files: **WinSetView.hta** (HTML GUI with VBScript code) and **WinSetView.ps1** (Powershell command line script).

Double-click WinSetView.hta to open the GUI. When you click Submit, the hta/vbs script will pass your choices as parameters to WinSetView.ps1, which will make the changes and then restart Explorer.

Each option, and related Explorer background information, is detailed below, but if you just want to get to it, the dialog is pretty much self-explanatory. For best results, close all open applications before running this tool. Open applications can prevent open/save dialog views from being updated.

All changes made by this tool are per-user within the HKEY_CURRENT_USER hive in the registry. No machine settings are touched and no elevated privileges are required. On each run, the tool makes a unique backup file of the affected registry values. A restore option is provided allowing you to rollback to any of these backups. There's also an option to completely reset all Explorer views to Windows default values.

# Options

## View Radio Buttons:
For your global Explorer view, you can select one of:
**Details, List, Tiles, Content, Small Icons, Medium Icons, Large Icons**
Your selection will apply to all folders except "This PC" and "Network". 

## Reset Views to Windows Defaults

This option clears the registry keys that hold Explore views and restarts Explorer, causing all folder views to revert to Windows defaults.

## No Grouping

This option turns off grouping in all folder views. This is most often desired for the **Downloads** folder which has grouping by date enabled by default.

## Make All folders Generic

This option disables "Folder Type Discovery". That's the windows feature that automatically changes a folder's view based on its contents. If you want your folder views to change with content, don't check this item. If you want a consistent view across all folders, regardless of content, check this option. This option also makes the Documents, Music, Pictures, and Videos folders generic. Those four folder will retain their special icons, but they will behave like a generic folder (i.e. column headings in Details view will be generic). This option has no effect on the Downloads folder.

## Set Global Column Headings

Check this box if you want to control which column headings are enabled globally for detailed view. Uncheck it if you want Windows default column headings. The column heading order is shown in the text box, using the heading names, as they are stored in the registry. To control the order, uncheck all column headings and then check them in the order you want them to appear left to right.

Sixteen of Explorer's column headings are provided. There are many more heading choices in Explorer, but these are the ones that are most likely to be applicable globally. Some of them appear redundant, but they're all different in some way. Each heading is explained below:

## Date headings:

**Date Modified**: The last date/time the file was updated on this file system.
**Date Created**: This is the date/time the file was initially written to storage.
**Date accessed**: Date file was last opened (rarely accurate due to deferred updates).

## General purpose headings:

**Size**: The file size in KB
**Attributes**: File attributes such as Archive[A], Hidden[H], System[S], Read-only[R]
**File Version**: Applicable to files that have a version header, such as .exe files

## File type headings:

**Item type**: The file's type based on file extension. Example: MPEG Layer 3
**Type**: Usually same as File type, but may show associated app name in search results.
**Perceived type**: File category. Examples: Audio, Video
**Kind**: Similar to Perceived type. Examples: Music, Video
**Content type**: Essentially Perceived type + Item type. Example: audio/mpeg
**File extension**: Example: .mp3 (handy for sorting if you don't need a type field)

## Path headings (useful in search results):

**Folder name**: The folder name only. Example: Ghibli
**Folder path**: Full path to the folder. Example: C:\Movies\Ghibli
**Folder**: Folder name followed by preceding path. Example: Ghibli (C:\Movies)
**Path**: Full path to the file. Example: C:\Movies\Ghibli\Ponyo.mkv

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

The Downloads folder, for example, has at least four different views. So, if you want grouping turned off for Downloads, you have to do it at least four times. Those four views are: 1) This PC, Downloads, 2) C:\Users\Username\Downloads, 3) This PC, Downloads via an Open or Save dialog, and 4) C:\Users\Username\Downloads via an Open or Save dialog. Frequently, a user will set one of these views and then encounter the other view and get angry that their view settings "didn't stick".

## Apply to Folders Explained

Another confusion is over the "Apply to folders" button. This can be found in **View**, **Options**, **Change folder and search options**, **View** tab. Many users interpret this button to mean "Apply to ALL folders". That's not what it means. It actually means "Apply to all folders that are the same type as the current folder". So, in the case of our Downloads example, each of those four views are different folder types, so the "Apply to folders" button will not help to set all Downloads views the same.

Explorer provides no option to set all folders and virtual folders to one global view. You can set a generic folder, such as C:\, to your desired views and then use the "Apply to folders" button to set all other generic folders the same. But, as explained, there are plenty of folders that are not generic folders. You can make the "Apply to folders" button apply to more folders by setting a registry value that tells Explorer to treat "all folders" as "Generic". That registry value is:

[HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell]
"FolderType"="Generic"

Note: You can substitute "Generic" with "NotSpecified" and get the same result.

Note: This tool makes this registry entry for you (if desired). It is only shown here for educational purposes.

With that value set, changing the view for say, C:\, and then clicking the "Apply to folders" button will also change the view for Documents, Music, Pictures, and Videos, but frustratingly, it will not change Downloads. Explorer really likes to keep the view for Downloads separate from all other folders.

## Apply to Folders "Bug"

Whenever you use the "Apply to folders" button, on any generic folder, such as C:\, your views for "This PC" and "Network" will revert back to Windows defaults. If you always leave "This PC" and "Network" at their default views, this is not an issue, but if you have changed either view and want to keep it changed, this is a nuisance.

There is a sort-of-okay workaround. Any folder that is open when "Apply to folders" is used, will not have it's view changed. So, to "protect" your custom views for "This PC" and "Network", be sure to have separate windows open to each of those views when you use the "Apply to folders" button.

## Automatic Folder Type Discovery

By default, Explorer has automatic folder discovery enabled. This means Explorer will automatically change the view of a folder based on its contents. People generally love or hate this feature. If you're reading this, you probably fall into the latter camp. The same "FolderType"="Generic" registry entry, described above, also disables automatic folder discovery. This option is applied by the tool when you select the **Make All Folders Generic** option.

For a lot of users, data specific views in Explorer are just an annoying distraction and the change of view from one folder to another is a jarring hinderance to efficient file management. For those users, a method to set consistent global Explorer views is a must. Enter this tool.

-----------------------------------------------------------------------------------

# FAQ

## How is this better than Explorer's "Apply to Folders"?

That option only applies your changes to folders of the *same type*. Explorer has many folder types, (e.g. Downloads, This PC, Search Results, Open/Save dialogs, etc.), requiring you to set your desired view options repeatedly. Additionally, many users encounter situations where their selected options are reverted back to Windows defaults for no obvious reason. This tool allows you to make quick *global* changes to your view settings that will not unexpectedly change.

## Does this tool require administrative privileges?

No. This tool creates a copy of the Windows folder view defaults, edits that copy, and applies it to the current user. The changes do not affect other users and are only part of the current user's profile.

## Is there an Undo?

Yes, as described under "Restore from Backup" above, the tool creates a backup every run that can be restored at any time. You can also revert the Explorer views to Windows defaults at any time.

## How does this tool work?

To answer that question, let's first look at how Explorer selects the views for your folders...

When a folder is opened, Explorer looks for existing view settings in the BagMRU/Bags keys:

HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU
HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags

If no settings exist there, it then checks the Streams key for any default settings that have been applied using the "Apply to folders" button:

HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Streams\Defaults

If the view settings are not in the Streams key, it checks the FolderTypes key in HKEY_LOCAL_MACHINE for the default view settings for the folder type that was just opened and applies those settings:

HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes

Explorer then saves the settings in an entry in the user's BagMRU/Bags keys that will be updated whenever the user changes the view for that folder.

Fortunately for us, Explorer will also look for the FolderTypes key in HKEY_CURRENT_USER and, if it exists, use that instead of the one in HKLM:

HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes

This provides an opportunity to inject our desired default settings without touching the base defaults for the machine and all other users (and not requiring admin privileges).

Note: Default views for all folders except "This PC" and "Network" can be found in the FolderTypes key.

**How This Tool Works**:

Here's an overview of the steps the Powershell script performs to set Explorer views as per the selected options:

1) Backup the existing user's registry keys that hold Explorer views
2) Delete those keys
3) Set any direct registry entries, such as Show File Extensions and Make All Folders Generic, for the current user.
4) If custom "This PC" and "Network" views have been selected, create BagMRU/Bags entries for those views.
5) Export HKEY_LOCAL_MACHINE FolderTypes key to a file.
6) Use Replace with regular expresions to change defaults in exported file as per user's selections.
7) Import edited FolderTypes key file to HKEY_CURRENT_USER.
8) Restart Explorer.

-----------------------------------------------------------------------------------

# Acknowledgements

Thanks to **Keith Miller** at TenForums.com for providing the FolderTypes approach to setting default views.

Thanks to my cat Puddles for keeping me company while I worked on this.
