using System;
using System.Windows.Forms;
using Microsoft.Win32;

namespace FileDialog
{
    class Program
    {
        [STAThread]
        static void Main(string[] args)
        {
            RegistryKey Software =
                Registry.CurrentUser.CreateSubKey("Software");
            using (RegistryKey
                FileDialog = Software.CreateSubKey("FileDialog"))
            {
                FileDialog.SetValue("", "?");
            }
            string fileName;
            fileName = "";
            bool multi;
            multi = true;
            if (args.Length >= 4)
            {
                multi = Convert.ToBoolean(args[3]);
            }
            if (args.Length >= 3)
            {
                args[2] = System.IO.Path.GetFullPath(System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, args[2]));

                if (args[0].Equals("Save"))
                {
                    SaveFileDialog fd = new SaveFileDialog
                    {
                        Filter = args[1],
                        InitialDirectory = args[2]
                    };
                    fd.ShowDialog();
                    fileName = fd.FileName;
                }
                if (args[0].Equals("Open"))
                {
                    OpenFileDialog fd = new OpenFileDialog
                    {
                        Filter = args[1],
                        InitialDirectory = args[2],
                        Multiselect = multi
                    };
                    fd.ShowDialog();
                    fileName = fd.FileName;
                }
                using (RegistryKey
                    FileDialog = Software.CreateSubKey("FileDialog"))
                {
                    FileDialog.SetValue("", fileName);
                }
            }
            else
            {
                Console.WriteLine("Usage: FileDialog.exe DialogType DialogFilter StartPath [Multiselect]");
                Console.WriteLine("Example: FileDialog.exe Open \"*.ini|*.ini\" C:\\Users false");
                Console.WriteLine("Example: FileDialog.exe Open \"*.ini|*.ini\" C:\\Users\\");
                Console.WriteLine("Example: FileDialog.exe Save \"Text files (*.txt)|*.txt\" \"C:\\Users\"");
                Console.WriteLine("Example: FileDialog.exe Save \"Text files (*.txt)|*.txt\" \"C:\\Users\\\\\"");
                Console.WriteLine("Example: FileDialog.exe Open \"Image Files(*.PNG;*.JPG)|*.PNG;*.JPG|All files (*.*)|*.*\" \"C:\\Users\"");
                Console.WriteLine("At start, ? is written to  HKCU\\Software\\FileDialog");
                Console.WriteLine("On Cancel, '' is written to  HKCU\\Software\\FileDialog");
                Console.WriteLine("On Open/Save, filename is written to HKCU\\Software\\FileDialog");
                Console.WriteLine("If StartPath is quoted, omit or double up trailing backslash");
                Console.WriteLine("Forward slashes may be used in place of backslash without any need to double up");
                Console.WriteLine("Relative paths are supported (e.g. .\\MyStuff or ..\\MyStuff)");
                Console.WriteLine("For Open DialogType, add \"false\" to turn off multiselect");
            }
        }
    }
}