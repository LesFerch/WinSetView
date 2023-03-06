# WinSetView

WinSetView is a tool that will let you easily set **File Explorer default folder views** (including turning off grouping everywhere if so desired). It works by setting registry values that File Explorer already supports. It does not modify Explorer or add any tasks or services.

Please follow the [quick start guide](./README.md) to download the app and set your initial folder view preferences. Running the app for the first time without following the guide may lead to confusion, as there are a lot of options on the screen.

![image](https://user-images.githubusercontent.com/79026235/223001030-8bdf160b-3b69-44a1-828b-d614a4da29ea.png)

WinSetView...

* Is a **portable app**. That is, it requires no installation (just unzip and run) and it saves its settings in an INI file with the app. So, you can easily run it from a flash drive or network drive to set up new computers and/or new users with consistent default views with just one click.

* Sets default folder views for ALL folder types, not just the basic five. That is, in addition to setting the default views for **General items**, **Documents**, **Pictures**, **Music**, and **Videos**, it also sets the default views for **Downloads**, **Libraries**, **OneDrive**, **Search results**, **Contacts**, **Quick Access**, **User files**, **File Open/Save dialogs**, etc.

* Can set the default view for **phones** and **tablets** to open in the same view you choose for General items. No more tiles!

* Sets folder views using the FolderTypes registry key which is not affected by **Windows updates**.

* Includes options to turn off Internet results in Windows search, revert the right-click menu to the classic layout, and disable thumbnails on folders.

* Can also be used to reset all folder views to **Windows defaults**.

* Can be used via the **command line** (for Power users and System Administrators). See the [*Tools Folder*](./Manual.md#tools-folder) section in the [manual](./Manual.md) for more details.

WinSetView will **correct** the following conditions (when the cause is registry corruption):

1. Folder views set via File Explorer, using **Apply to Folders**, are not applying to all folders.
2. Folder Properties, Customize, **Optimize this folder for** is not working properly.
3. Folder views are reverting back to **Windows defaults**.

**Note**: **Windows 11** currently has some folder view bugs in regards to setting folder type for entire folder trees on removable drives and overriding the automatically detected folder type on "Local disks". Those bugs can, for now, be eliminated by installing a program that patches Explorer, such as **[StartAllBack](https://www.startallback.com)** (with the Explorer style option set to one of the classic views).

![image](https://user-images.githubusercontent.com/79026235/152913587-d294de81-c8ca-428d-b351-09a564854eff.png)
[See the quick start guide](./README.md)
