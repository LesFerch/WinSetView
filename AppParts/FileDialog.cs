using System;
using System.Windows.Forms;
using Microsoft.Win32;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Runtime.InteropServices.ComTypes;

namespace FileDialog
{
    class Program
    {
        [STAThread]
        static void Main(string[] args)
        {
            RegistryKey Software = Registry.CurrentUser.CreateSubKey("Software");
            using (RegistryKey FileDialog = Software.CreateSubKey("FileDialog"))
            {
                FileDialog.SetValue("", "?");
                FileDialog.SetValue("ItemList", "?");
                FileDialog.SetValue("ItemListM", "?");
            }
            string arg = "";
            string DialogType = "";
            string DialogTitle = "";
            string FileFilter = "";
            string TestPath = "";
            string StartPath = "";
            string fileName = "";
            string fileNames = "";
            bool Multi = false;
            bool Retro = false;
            var ItemList = new List<string>();
            for (int i = 0; i < args.Length; i++)
            {
                arg = args[i].ToLower();

                arg = Environment.ExpandEnvironmentVariables(arg);

                arg = arg.Replace("%documents%", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}");
                arg = arg.Replace("%libraries%", "::{031E4825-7B94-4dc3-B131-E946B44C8DD5}");
                arg = arg.Replace("%thispc%", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}");
                arg = arg.Replace("%this pc%", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}");

                try { TestPath = System.IO.Path.GetFullPath(System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, arg)); }
                catch { }
                if (System.IO.Directory.Exists(TestPath)) { StartPath = TestPath; }

                if (arg == "documents") { StartPath = "::{450D8FBA-AD25-11D0-98A8-0800361B1103}"; }
                if (arg == "libraries") { StartPath = "::{031E4825-7B94-4dc3-B131-E946B44C8DD5}"; }
                if (arg == "onedrive") { StartPath = "::{018D5C66-4533-4307-9B53-224DE2ED1FE6}"; }
                if (arg == "public") { StartPath = "::{4336a54d-038b-4685-ab02-99bb52d3fb8b}"; }
                if (arg == "thispc") { StartPath = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"; }
                if (arg == "this pc") { StartPath = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"; }
                if (arg == "userprofile") { StartPath = "::{59031a47-3f72-44a7-89c5-5595fe6b30ee}"; }
                if (arg == "desktop") { StartPath = "::{59031a47-3f72-44a7-89c5-5595fe6b30ee}\\desktop"; }
                if (arg == "downloads") { StartPath = "::{59031a47-3f72-44a7-89c5-5595fe6b30ee}\\downloads"; }
                if (arg == "music") { StartPath = "::{59031a47-3f72-44a7-89c5-5595fe6b30ee}\\music"; }
                if (arg == "pictures") { StartPath = "::{59031a47-3f72-44a7-89c5-5595fe6b30ee}\\pictures"; }
                if (arg == "videos") { StartPath = "::{59031a47-3f72-44a7-89c5-5595fe6b30ee}\\videos"; }

                if (arg == "open") { DialogType = "Open"; }
                if (arg == "save") { DialogType = "Save"; }
                if (arg == "folder") { DialogType = "Folder"; }

                if (arg == "multi") { Multi = true; }
                if (arg == "retro") { Retro = true; }

                if (arg.Contains("|")) { FileFilter = args[i]; }

                if (arg.Substring(0, 1) == "~") { DialogTitle = args[i].Substring(1); }
            }
            if (DialogType != "")
            {
                if (StartPath.Contains("::")) { Retro = false; }
                if (DialogType == "Open")
                {
                    OpenFileDialog fd = new OpenFileDialog
                    {
                        Title = DialogTitle,
                        Filter = FileFilter,
                        InitialDirectory = StartPath,
                        Multiselect = Multi
                    };
                    if (Retro) { fd.AutoUpgradeEnabled = false; }
                    fd.ShowDialog();
                    fileName = fd.FileName;
                    foreach (String file in fd.FileNames)
                    {
                        if (fileNames != "") { fileNames = fileNames + '"' + ',' + '"'; }
                        fileNames += file;
                        ItemList.Add(file);
                    }
                }
                if (DialogType == "Save")
                {
                    SaveFileDialog fd = new SaveFileDialog
                    {
                        Title = DialogTitle,
                        Filter = FileFilter,
                        InitialDirectory = StartPath,
                    };
                    if (Retro) { fd.AutoUpgradeEnabled = false; }
                    fd.ShowDialog();
                    fileName = fd.FileName;
                    fileNames = fd.FileName;
                    ItemList.Add(fd.FileName);
                }
                if (DialogType == "Folder")
                {
                    if (Retro)
                    {
                        FolderBrowserDialog fd = new FolderBrowserDialog
                        {
                            SelectedPath = StartPath,
                        };
                        fd.ShowDialog();
                        {
                            fileName = fd.SelectedPath;
                            fileNames = fd.SelectedPath;
                            ItemList.Add(fd.SelectedPath);
                        }
                    }
                    else
                    {
                        FolderPicker fd = new FolderPicker
                        {
                            Title = DialogTitle,
                            InputPath = StartPath,
                        };
                        if (fd.ShowDialog(IntPtr.Zero) == true)
                        {
                            fileName = fd.ResultPath;
                            fileNames = fd.ResultPath;
                            ItemList.Add(fd.ResultPath);
                        }
                    }
                }
                if (fileNames != "") { fileNames = '"' + fileNames + '"'; }
                using (RegistryKey FileDialog = Software.CreateSubKey("FileDialog"))
                {
                    FileDialog.SetValue("", fileName);
                    FileDialog.SetValue("ItemList", fileNames);
                    FileDialog.SetValue("ItemListM", ItemList.ToArray(), RegistryValueKind.MultiString);
                }
                Console.WriteLine(fileNames);
            }
            else
            {
                Console.WriteLine(@"Usage: FileDialog DialogType [~DialogTitle] [StartPath] [DialogFilter] [Multi] [Retro]");
                Console.WriteLine(@"DialogType must be one of: Open Save Folder");
                Console.WriteLine(@"Parameters may be specified in any order and are not case sensitive");
                Console.WriteLine(@"Prefix DialogTitle with ~ Example: ~""Select an image file""");
                Console.WriteLine(@"Parameters must be quoted if they contains spaces");
                Console.WriteLine(@"If StartPath is quoted, omit or double up trailing backslash");
                Console.WriteLine(@"Forward slashes may be used in place of backslash without any need to double up");
                Console.WriteLine(@"Relative paths are supported (e.g. .\MyStuff or ..\MyStuff)");
                Console.WriteLine(@"Supported StartPath shortcuts: Documents Libraries OneDrive Public ThisPC UserProfile");
                Console.WriteLine(@"Multiselect is supported for File Open dialogs and is OFF by default.");
                Console.WriteLine(@"The Retro parameter will give you old school Open, Save, and Folder select dialogs");
                Console.WriteLine(@"Microsoft's modern dialogs insist on going to Libraries for Documents, Pictures, and so on");
                Console.WriteLine(@"Use the Retro parameter to avoid Libraries");
                Console.WriteLine(@"The Retro parameter is ignored if using a StartPath shortcut");
                Console.WriteLine(@"Environment variables are supported. Be sure to quote them if they contain spaces.");
                Console.WriteLine(@"Example: FileDialog Open C:\Users ""*.ini|*.ini"" Multi");
                Console.WriteLine(@"Example: FileDialog Open C:\Users\ ""*.ini|*.ini"" ~""Select an INI file""");
                Console.WriteLine(@"Example: FileDialog Save ""C:\Users"" ""Text files (*.txt)|*.txt""");
                Console.WriteLine(@"Example: FileDialog Save ""C:\Users\\"" ""Text files (*.txt)|*.txt""");
                Console.WriteLine(@"Example: FileDialog Open ""C:\Users"" ""Image Files(*.PNG;*.JPG)|*.PNG;*.JPG|All files (*.*)|*.*""");
                Console.WriteLine(@"Example: FileDialog Open UserProfile");
                Console.WriteLine(@"Example: FileDialog Folder ThisPC");
                Console.WriteLine(@"Example: FileDialog Open ""%UserProfile%\Pictures"" Retro");
                Console.WriteLine(@"Example: FileDialog Open ""C:\Users\Public\Documents"" Retro");
                Console.WriteLine(@"Example: FileDialog Open ""%LocalAppData%""");
                Console.WriteLine(@"At start, ? is written to  HKCU\Software\FileDialog");
                Console.WriteLine(@"On Cancel, '' is written to  HKCU\Software\FileDialog");
                Console.WriteLine(@"Upon user selection, a single, unquoted item is written to HKCU\Software\FileDialog Default");
                Console.WriteLine(@"Selected items are written in CSV format to the console and HKCU\Software\FileDialog ItemList");
                Console.WriteLine(@"Selected items are also written as a multi-string to HKCU\Software\FileDialog ItemListM");
            }
        }
    }
    public class FolderPicker
    //Courtesy of Simon Mourier https://stackoverflow.com/a/66187224/15764378
    {
        public virtual string ResultPath { get; protected set; }
        public virtual string ResultName { get; protected set; }
        public virtual string InputPath { get; set; }
        public virtual bool ForceFileSystem { get; set; }
        public virtual string Title { get; set; }
        public virtual string OkButtonLabel { get; set; }
        public virtual string FileNameLabel { get; set; }
        protected virtual int SetOptions(int options)
        {
            if (ForceFileSystem)
            {
                options |= (int)FOS.FOS_FORCEFILESYSTEM;
            }
            return options;
        }
        public virtual bool? ShowDialog(IntPtr owner, bool throwOnError = false)
        {
            var dialog = (IFileOpenDialog)new FileOpenDialog();
            if (!string.IsNullOrEmpty(InputPath))
            {
                if (CheckHr(SHCreateItemFromParsingName(InputPath, null, typeof(IShellItem).GUID, out var item), throwOnError) != 0)
                    return null;
                dialog.SetFolder(item);
            }
            var options = FOS.FOS_PICKFOLDERS;
            options = (FOS)SetOptions((int)options);
            dialog.SetOptions(options);
            if (Title != null)
            {
                dialog.SetTitle(Title);
            }
            if (OkButtonLabel != null)
            {
                dialog.SetOkButtonLabel(OkButtonLabel);
            }
            if (FileNameLabel != null)
            {
                dialog.SetFileName(FileNameLabel);
            }
            if (owner == IntPtr.Zero)
            {
                owner = Process.GetCurrentProcess().MainWindowHandle;
                if (owner == IntPtr.Zero)
                {
                    owner = GetDesktopWindow();
                }
            }
            var hr = dialog.Show(owner);
            if (hr == ERROR_CANCELLED)
                return null;
            if (CheckHr(hr, throwOnError) != 0)
                return null;
            if (CheckHr(dialog.GetResult(out var result), throwOnError) != 0)
                return null;
            if (CheckHr(result.GetDisplayName(SIGDN.SIGDN_DESKTOPABSOLUTEPARSING, out var path), throwOnError) != 0)
                return null;
            ResultPath = path;
            if (CheckHr(result.GetDisplayName(SIGDN.SIGDN_DESKTOPABSOLUTEEDITING, out path), false) == 0)
            {
                ResultName = path;
            }
            return true;
        }
        private static int CheckHr(int hr, bool throwOnError)
        {
            if (hr != 0)
            {
                if (throwOnError)
                    Marshal.ThrowExceptionForHR(hr);
            }
            return hr;
        }
        [DllImport("shell32")]
        private static extern int SHCreateItemFromParsingName([MarshalAs(UnmanagedType.LPWStr)] string pszPath, IBindCtx pbc, [MarshalAs(UnmanagedType.LPStruct)] Guid riid, out IShellItem ppv);
        [DllImport("user32")]
        private static extern IntPtr GetDesktopWindow();
        private const int ERROR_CANCELLED = unchecked((int)0x800704C7);
        [ComImport, Guid("DC1C5A9C-E88A-4dde-A5A1-60F82A20AEF7")] // CLSID_FileOpenDialog
        private class FileOpenDialog
        {
        }
        [ComImport, Guid("42f85136-db7e-439c-85f1-e4075d135fc8"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        private interface IFileOpenDialog
        {
            [PreserveSig] int Show(IntPtr parent); // IModalWindow
            [PreserveSig] int SetFileTypes();  // not fully defined
            [PreserveSig] int SetFileTypeIndex(int iFileType);
            [PreserveSig] int GetFileTypeIndex(out int piFileType);
            [PreserveSig] int Advise(); // not fully defined
            [PreserveSig] int Unadvise();
            [PreserveSig] int SetOptions(FOS fos);
            [PreserveSig] int GetOptions(out FOS pfos);
            [PreserveSig] int SetDefaultFolder(IShellItem psi);
            [PreserveSig] int SetFolder(IShellItem psi);
            [PreserveSig] int GetFolder(out IShellItem ppsi);
            [PreserveSig] int GetCurrentSelection(out IShellItem ppsi);
            [PreserveSig] int SetFileName([MarshalAs(UnmanagedType.LPWStr)] string pszName);
            [PreserveSig] int GetFileName([MarshalAs(UnmanagedType.LPWStr)] out string pszName);
            [PreserveSig] int SetTitle([MarshalAs(UnmanagedType.LPWStr)] string pszTitle);
            [PreserveSig] int SetOkButtonLabel([MarshalAs(UnmanagedType.LPWStr)] string pszText);
            [PreserveSig] int SetFileNameLabel([MarshalAs(UnmanagedType.LPWStr)] string pszLabel);
            [PreserveSig] int GetResult(out IShellItem ppsi);
            [PreserveSig] int AddPlace(IShellItem psi, int alignment);
            [PreserveSig] int SetDefaultExtension([MarshalAs(UnmanagedType.LPWStr)] string pszDefaultExtension);
            [PreserveSig] int Close(int hr);
            [PreserveSig] int SetClientGuid();  // not fully defined
            [PreserveSig] int ClearClientData();
            [PreserveSig] int SetFilter([MarshalAs(UnmanagedType.IUnknown)] object pFilter);
            [PreserveSig] int GetResults([MarshalAs(UnmanagedType.IUnknown)] out object ppenum);
            [PreserveSig] int GetSelectedItems([MarshalAs(UnmanagedType.IUnknown)] out object ppsai);
        }
        [ComImport, Guid("43826D1E-E718-42EE-BC55-A1E261C37BFE"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        private interface IShellItem
        {
            [PreserveSig] int BindToHandler(); // not fully defined
            [PreserveSig] int GetParent(); // not fully defined
            [PreserveSig] int GetDisplayName(SIGDN sigdnName, [MarshalAs(UnmanagedType.LPWStr)] out string ppszName);
            [PreserveSig] int GetAttributes();  // not fully defined
            [PreserveSig] int Compare();  // not fully defined
        }
        private enum SIGDN : uint
        {
            SIGDN_DESKTOPABSOLUTEEDITING = 0x8004c000,
            SIGDN_DESKTOPABSOLUTEPARSING = 0x80028000,
            SIGDN_FILESYSPATH = 0x80058000,
            SIGDN_NORMALDISPLAY = 0,
            SIGDN_PARENTRELATIVE = 0x80080001,
            SIGDN_PARENTRELATIVEEDITING = 0x80031001,
            SIGDN_PARENTRELATIVEFORADDRESSBAR = 0x8007c001,
            SIGDN_PARENTRELATIVEPARSING = 0x80018001,
            SIGDN_URL = 0x80068000
        }
        [Flags]
        private enum FOS
        {
            FOS_OVERWRITEPROMPT = 0x2,
            FOS_STRICTFILETYPES = 0x4,
            FOS_NOCHANGEDIR = 0x8,
            FOS_PICKFOLDERS = 0x20,
            FOS_FORCEFILESYSTEM = 0x40,
            FOS_ALLNONSTORAGEITEMS = 0x80,
            FOS_NOVALIDATE = 0x100,
            FOS_ALLOWMULTISELECT = 0x200,
            FOS_PATHMUSTEXIST = 0x800,
            FOS_FILEMUSTEXIST = 0x1000,
            FOS_CREATEPROMPT = 0x2000,
            FOS_SHAREAWARE = 0x4000,
            FOS_NOREADONLYRETURN = 0x8000,
            FOS_NOTESTFILECREATE = 0x10000,
            FOS_HIDEMRUPLACES = 0x20000,
            FOS_HIDEPINNEDPLACES = 0x40000,
            FOS_NODEREFERENCELINKS = 0x100000,
            FOS_OKBUTTONNEEDSINTERACTION = 0x200000,
            FOS_DONTADDTORECENT = 0x2000000,
            FOS_FORCESHOWHIDDEN = 0x10000000,
            FOS_DEFAULTNOMINIMODE = 0x20000000,
            FOS_FORCEPREVIEWPANEON = 0x40000000,
            FOS_SUPPORTSTREAMABLEITEMS = unchecked((int)0x80000000)
        }
    }
}