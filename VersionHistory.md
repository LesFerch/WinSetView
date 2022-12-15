## 2.53

Enhancement: The File Explorer window size and position is now retained.

Enhancement: The WinSetView window size and position is now remembered. Also added a "Re-center" button to center the app on the primary display.

Enhancement: Display tweaks made to work better with Window's high contrast mode.

Enhancement: Changed icons for Details and Right-Click column headings.

Enhancement: Updated column clear dialogs to new format that matches scale of main screen.

Enhancement: When a new version is available, the "Help" button changes to "Update" with the version information in the tooltip.

Feature added: Separate views for File Open/Save dialogs can now be set on a per folder type basis.

Feature added: The Grouping column heading button now has ascending and descending order options.

Feature added: Drag sort dialog added for rearranging column headings.

Feature added: Copy and Paste buttons added for easy copying of view settings from one folder type to another.

Feature added: Uncheck/Recheck all checkbox added to the Advanced interface (handy when you want the majority of the folder type views left at Windows defaults).

Feature added: There's now an extendable Theme menu with light and dark themes provided.

## 2.46

Enhancement: Windows 11 "Home" folder now indicated for all languages.

## 2.45

Bug Fix: Fixed "File not found" error on machines where the PowerShell startup folder is set via Profile.ps1.

Bug Fix: Fixed file dialog still grouped when Explorer view is grouped, but file dialogs are set to Not Grouped.

## 2.44

Enhancement: Column width can now be set as high as 999 ems (7992 pixels at 96 dpi).

## 2.43

Bug Fix: Corrected Details view icon size in legacy dialogs (e.g. RegEdit Export dialog, IrfanView Open/Save dialogs).

Enhancement: Hover over Help button to see version number.


## 2.42

Bug Fix: "Set view for This PC" now enables grouping when "No Grouping" is unchecked.

Bug Fix: "Set view for Network" now actually works.

Enhancement: "Reset Views to Windows Defaults" now deletes entire Explorer Streams key instead of just Streams/Defaults.

Enhancement: Updated the INI files to change some defaults in the Options menu.

Enhancement: Now detects if WinSetView.HTA is launched directly from zip file and displays error.

Enhancement: FileDialog.exe updated to latest version (no impact on WinSetView functionality)


## 2.41

Bug Fix: Inspect (magnifying glass) icon now always hidden unless Advanced interface is selected.

Enhancement: Added Vietnamese language.


## 2.40

Feature added: Disable Folder Thumbnails.


## 2.33

Enhancement: Minor code change to ensure quick exit.


## 2.32

Bug Fix: Rewrote Windows version checking so that it now runs on Windows Server.

Bug Fix: Fixed an issue with incorrect display when switching languages.

Enhancement: FileDialog.exe updated to latest version (no impact on WinSetView functionality)

Enhancement: Disabled the HTA built-in context menu as it provides nothing useful for the app.

Enhancement: Disabled F5 and Ctrl-F5 refresh.

Enhancement: Tidied up code that determines current directory.


## 2.30

Bug Fix: Removed "Language=en-US" from default INI file so that system language is detected.

Feature added: Help button (Opens WinSetView web page)

Feature added: Standard and Advanced interface selection.

Enhancement: Added en-GB language for UK, Canada, Australia, etc.


## 2.20

Feature added: "Set view for Network" (actually never worked - fixed in 2.42)


## 2.16

Bug Fix: Now runs correctly from a folder in Program Files or Program Files (x86).


## 2.15

Bug Fix: Unchecking/checking a folder type now properly hides and unhides elements.


## 2.14

Bug Fix: "Use General Items view for connected devices" checkbox now scales properly.


## 2.13

Enhancement: Now detects if current directory name contains square brackets (incompatible with PowerShell) and displays error.


## 2.12

Bug Fix: HTA now explicitly sets its mode, so that it cannot be set to an incorrect mode via the registry.

Bug Fix: Fixed some display issues with some items not hidden when they should be.

Enhancement: Alt key can now be used with Submit button to keep PowerShell console open.


## 2.11

Bug Fix: Now runs from a UNC path.


## 2.10

Feature added: "Use General Items view for connected devices"


## 2.03

Feature added: Columns widths can now be entered in pixels (use Alt key).


## 2.02

First 2.x release.
