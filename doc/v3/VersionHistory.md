## 3.1.4

Enhancement: Added "ResetWindowMetrics.cmd" script.

Enhancement: New human-translated Italian language files (thanks to GitHub user topoldo).

Enhancement: Many other language files improved via contextual AI translation.

Bug Fix: Fixed error that occurred when using "Detect current settings" in "Explorer Options" when a default starting folder for Explorer has never been set.

## 3.1.3

Enhancement: Improved/added warning and error messages

## 3.1.2

Bug Fix: Fixed label click for "Remove Home in Windows 11" and "Remove Gallery in Windows 11"

## 3.1.1

Feature added: General items column settings can now be applied to MTP devices such as phones.

Feature added: "Remove Home in Windows 11" and "Remove Gallery in Windows 11" options added.

Feature added: "Auto arrange" and "Align to grid" defaults added for "Windows XP/Vista view mode".

Feature added: Added "Detect current settings" button to Folder View Options page.

Enhancement: Checkbox labels in the main and options pages are now clickable.

Enhancement: Now runs on MSHTML 8 through 11. This allows it to run on a basic Windows 7 SP1 build without having to install IE 11.

Change: VBScript code replaced with [JScript](https://en.wikipedia.org/wiki/JScript) code.

Change: Removed check for new version on startup. This could cause startup delays depending on network settings. There is now a button to check for a new version.

Change: Renamed option "Legacy row and icon spacing" to "Windows XP/Vista view mode"

Change: "Disable folder thumbnails" moved from "Explorer Options" to "Folder View Options"

## 3.0.3

Bug Fix: Fixed error that occurs only when PowerShell is in constrained mode.

## 3.0.2

Bug Fix: Fixed error that caused file dialog views to not always be set for specific folder types.

Bug Fix: General items view for connected devices (such as phones) now also applies to dialog views.

## 3.0.1

Bug Fix: Detect current settings now detects if Windows 10 classic search is enabled or disabled.

## 3.0.0

Feature added: Options have been split into Folder View Options and Explorer Options.

Feature added: Added button to detect current Explorer Options.

Feature added: Submit now opens a dialog to choose Folder views and/or Explorer options.

Feature added: New option to Unhide the Public Desktop folder.

Feature added: Added a checkbox to enable/disable backup.

## 2.99.1

Enhancement: Now works on systems that have the DisableRegistryTools policy enabled.

Enhancement: PowerShell scripts updated to work with PowerShell Core.

Enhancement: Corrections to French language file (Thank you k3lteris).

Bug Fix: Fixed error in build version check that prevented Windows 10 Explorer from being enabled on Windows 11 24H2.

## 2.99

Bug Fix: Fixed problem, introduced with 2.97, with header being blank after switching language.

## 2.98

Bug Fix: Fixed issue, introduced with 2.97, that caused error when running from a path containing a space.

## 2.97

Feature added: All third-party shell properties are now dynamically added to the column selection list.

Feature added: Option to set Show hidden files and folders.

Feature added: Option to enable Copy/Move To folder context menu items.

Enhancement: The AppData folder is now dynamically created to protect user's existing WinSetView settings when updating the app.

Enhancement: Help button is now context sensitive.

Change: PowerShell is now run via its absolute path instead of relying on the System path.

Change: The default setting for "Use General Items view for connected devices" is now off.

## 2.96

Enhancement: Added all of the available [Icaros](https://github.com/Xanashi/Icaros) property translations.

## 2.95

Feature added: If [Icaros](https://github.com/Xanashi/Icaros) Properties are activated, those properties will be available to use from the WinSetView Columns page.

## 2.94

Enhancement: Libraries now automatically get the usual headers that show the path and drive. The Option menu provides an override for the automatic grouping.

## 2.93

Bug fix: Windows 10 Explorer on Windows 11 now remembers its window size and position.

## 2.92

Enhancement: Explorer start folder options expanded.

Change: Option to disable feature 40729001 is now only shown on older builds where it still can be used.

## 2.91

Bug fix: Legacy row and icon spacing is not compatible with dark mode. It is now disabled and hidden when the computer is in dark mode.

Enhancement: Black and white lock icon replaced with color UAC shield icon.

## 2.90

Feature added: Option to use Windows 10 Explorer on Windows 11.

Feature added: Option to fix Desktop place in legacy dialogs in Windows 11.

Feature added: Option to set a custom start folder for Explorer.

Feature added: Option to enable legacy row and icon spacing.

Feature added: Option to disable full row select (requires legacy spacing).

Enhancement: Modal dialogs now follow theme colors.

Enhancement: Large and extra large icons added to WinSetView.exe.

## 2.80

Feature added: Option to disable "Let's finish" and other "suggestions".

Feature added: Option to disable numerical sort order.

Feature added: Option to enable feature 18755234 (Windows 10 search).

Feature added: Option to disable feature 40729001 (Windows 11 Explorer).

Enhancement: All options are now visible in the Standard interface.

Enhancement: Improvements to theme colors.

## 2.77

Bug Fix: Fixed issue on Windows 7 x64 that caused an error with the Change column order feature.

Enhancement: Now displays an error message if VBScript.dll has been disabled or uninstalled.

Enhancement: Now fully compatible with PowerShell running in Constrained Language Mode.

Enhancement: An irrelevant error message, that showed in the console only for a new user, is now suppressed.

## 2.76

Bug Fix: Sort 4 removed because Explorer does not handle more than three sort levels via the FolderTypes registry key, even though Microsoft has four sort levels set in that key for Music library and Music search results. A fourth sort level causes sorting to revert to the default of sort by Name and can also cause the ribbon's Sort menu items to be grayed out in Windows 11 or not shown at all in Windows 10.

## 2.75

Bug Fix: Fixed Windows 11 Sort menu items grayed out (in views other than Details) when the option "Use General Items view for connected devices" is checked.

## 2.74

Bug Fix: Fixed issue on Windows 7 and 8 that caused Desktop icons to get auto-arranged.

Enhancement: Now exits with error if MSHTML version is less than 11 (applicable to a non-updated Windows 7).

Enhancement: New option (in Advanced interface) to allow non-standard grouping of the Home / Quick Access folder.

Enhancement: Toolbars are now preserved when using the option "Reset Views to Windows Defaults"

## 2.73

Bug Fix: Corrected issue with dialogs in the app being sized too small vertically.

## 2.72

Feature added: Option to enable Classic Search in Windows 10.

Bug Fix: In order to work with the new Windows App SDK version of File Explorer (currently only available in the Canary build) the HomeFolder type is now always set to group by group.

## 2.71

Bug Fix: If WinSetView is closed while minimized, it now re-opens on screen.

Bug Fix: WinSetView now re-centers its window correctly with a top-positioned taskbar.

## 2.70

Enhancement: WinSetView.exe is now a VbsEdit HTML application. This will allow it to run on computers where MSHTA has been blocked.

## 2.66

Bug Fix: Microsoft Store apps, that save folder views in a Windows Container hive file, such as the Windows 11 Notepad and Paint, now get their file dialog views set by WinSetView.

Note: This is the last version that runs via MSHTA.exe.

## 2.65

Bug Fix: Custom icon size was not being applied to "General items" type folders or "This PC" when the option "Use General Items view for connected devices" was also checked.

## 2.64

Feature added: Option to unhide the AppData folder

Enhancement: Better looking button icons

## 2.63

Bug Fix: Views for UNC paths (e.g. \\\192.168.1.1\Share) are now cleared so that the new folder view defaults will take effect. Network drives mapped to drive letters were never affected by this issue.

Change: The RollbackExplorer.vbs script has been removed from the package because it is not compatible with Windows 11 build 22621.1344 (or higher).

## 2.62

Bug Fix: The new modal Restore/Load/Save dialogs now work when there is a space in WinSetView's path.

Change: Cannot find a way to reliably set Network view. Option has been removed.

## 2.61

Bug Fix: Thumbnail cache is now consistently reset when using "Disable folder thumbnails"

Bug Fix: Starting location for Restore/Load/Save correct now when running from a read-only directory.

Bug Fix: Corrected error that could occur when Restore/Load/Save are repeatedly clicked. Fixed by making those dialogs modal.

## 2.60

Feature added: Option to enable the classic context menu in Windows 11

Feature added: Option to have no Internet results in Windows search

Feature added: Option to disable search highlights

Enhancement: A WinSetView.exe launcher is now included to simplify execution on computers where MSHTA.exe is not correctly associated to HTA files.

Enhancement: Now runs without error on machines where System32 is missing from the Path environment variable

Bug Fix: Dialogs now reduce in width appropriately if the WinSetView window is set very narrow

Bug Fix: Fixed minor issues with display scaling and positioning.

## 2.53

Feature added: Separate views for File Open/Save dialogs can now be set on a per folder type basis.

Feature added: The Grouping column heading button now has ascending and descending order options.

Feature added: Drag sort dialog added for rearranging column headings.

Feature added: Copy and Paste buttons added for easy copying of view settings from one folder type to another.

Feature added: Uncheck/Recheck all checkbox added to the Advanced interface (handy when you want the majority of the folder type views left at Windows defaults).

Feature added: There's now an extendable Theme menu with light and dark themes provided.

Enhancement: The File Explorer window size and position is now retained.

Enhancement: The WinSetView window size and position is now remembered. Also added a "Re-center" button to center the app on the primary display.

Enhancement: Display tweaks made to work better with Window's high contrast mode.

Enhancement: Changed icons for Details and Right-Click column headings.

Enhancement: Updated column clear dialogs to new format that matches scale of main screen.

Enhancement: When a new version is available, the "Help" button changes to "Update" with the version information in the tooltip.

## 2.46

Enhancement: Windows 11 "Home" folder now indicated for all languages.

## 2.45

Bug Fix: Fixed "File not found" error on machines where the PowerShell startup folder is set via Profile.ps1.

Bug Fix: Fixed file dialog still grouped when Explorer view is grouped, but file dialogs are set to Not Grouped.

## 2.44

Enhancement: Column width can now be set as high as 999 ems (7992 pixels at 96 dpi).

## 2.43

Enhancement: Hover over Help button to see version number.

Bug Fix: Corrected Details view icon size in legacy dialogs (e.g. RegEdit Export dialog, IrfanView Open/Save dialogs).

## 2.42

Enhancement: "Reset Views to Windows Defaults" now deletes entire Explorer Streams key instead of just Streams/Defaults.

Enhancement: Updated the INI files to change some defaults in the Options menu.

Enhancement: Now detects if WinSetView.HTA is launched directly from zip file and displays error.

Enhancement: FileDialog.exe updated to latest version (no impact on WinSetView functionality)

Bug Fix: "Set view for This PC" now enables grouping when "No Grouping" is unchecked.

## 2.41

Enhancement: Added Vietnamese language.

Bug Fix: Inspect (magnifying glass) icon now always hidden unless Advanced interface is selected.

## 2.40

Feature added: Disable Folder Thumbnails.

## 2.33

Enhancement: Minor code change to ensure quick exit.

## 2.32

Enhancement: FileDialog.exe updated to latest version (no impact on WinSetView functionality)

Enhancement: Disabled the HTA built-in context menu as it provides nothing useful for the app.

Enhancement: Disabled F5 and Ctrl-F5 refresh.

Enhancement: Tidied up code that determines current directory.

Bug Fix: Rewrote Windows version checking so that it now runs on Windows Server.

Bug Fix: Fixed an issue with incorrect display when switching languages.

## 2.30

Feature added: Help button (Opens WinSetView web page)

Feature added: Standard and Advanced interface selection.

Enhancement: Added en-GB language for UK, Canada, Australia, etc.

Bug Fix: Removed "Language=en-US" from default INI file so that system language is detected.

## 2.20

Feature added: "Set view for Network" (unreliable - removed in 2.62)

## 2.16

Bug Fix: Now runs correctly from a folder in Program Files or Program Files (x86).

## 2.15

Bug Fix: Unchecking/checking a folder type now properly hides and unhides elements.

## 2.14

Bug Fix: "Use General Items view for connected devices" checkbox now scales properly.

## 2.13

Enhancement: Now detects if current directory name contains square brackets (incompatible with PowerShell) and displays error.

## 2.12

Enhancement: Alt key can now be used with Submit button to keep PowerShell console open.

Bug Fix: HTA now explicitly sets its mode, so that it cannot be set to an incorrect mode via the registry.

Bug Fix: Fixed some display issues with some items not hidden when they should be.

## 2.11

Bug Fix: Now runs from a UNC path.

## 2.10

Feature added: "Use General Items view for connected devices"

## 2.03

Feature added: Columns widths can now be entered in pixels (use Alt key).

## 2.02

First 2.x release.
