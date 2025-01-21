using System;
using System.IO;
using Microsoft.Win32;
using System.Linq;
using System.Collections.Generic;
using System.Text;

namespace CSReg
{
    internal class Program
    {
        // Global variable to control verbose output
        static bool isVerbose = false;

        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("No arguments provided. Please specify an action.");
                return;
            }

            // Check if /verbose is passed as an argument
            isVerbose = args.Contains("/verbose");

            // Filter out "/verbose" from the args so it doesn't interfere with command processing
            args = args.Where(arg => arg.ToLower() != "/verbose").ToArray();

            string action = args[0].ToLower();

            switch (action)
            {
                case "import":
                    if (args.Length < 2)
                    {
                        Console.WriteLine("Usage: REG IMPORT FileName");
                        return;
                    }
                    ImportRegistryFile(args[1]);
                    break;

                case "export":
                    if (args.Length < 3)
                    {
                        Console.WriteLine("Usage: REG EXPORT KeyName FileName [/y]");
                        return;
                    }
                    ExportRegistryKey(args[1], args[2], args.Contains("/y"));
                    break;

                case "delete":
                    if (args.Length < 2)
                    {
                        Console.WriteLine("Usage: REG DELETE KeyName [/v ValueName | /ve | /va] [/f]");
                        return;
                    }
                    DeleteRegistryKeyOrValue(args);
                    break;

                case "query":
                    if (args.Length < 2)
                    {
                        Console.WriteLine("Usage: REG QUERY KeyName [/v [ValueName] | /ve]");
                        return;
                    }
                    QueryRegistryKeyOrValue(args);
                    break;

                case "add":
                    if (args.Length < 2)
                    {
                        Console.WriteLine("Usage: REG ADD KeyName [/v ValueName | /ve] [/t Type] [/d Data] [/f]");
                        return;
                    }
                    AddRegistryKeyOrValue(args);
                    break;

                default:
                    Console.WriteLine("Unsupported action. Use import, export, delete, query, or add.");
                    break;
            }
        }

        // Helper method to display success messages
        static void DisplaySuccessMessage(string detailedMessage)
        {
            if (isVerbose)
            {
                Console.WriteLine(detailedMessage);
            }
            else
            {
                Console.WriteLine("The operation completed successfully.");
            }
        }

        // ADD function
        static void AddRegistryKeyOrValue(string[] args)
        {
            string keyPath = null;
            string valueName = "";
            string valueData = "";
            RegistryValueKind valueType = RegistryValueKind.String; // Default to REG_SZ
            bool force = false;

            // Start processing from args[1], where the key\subkey is located
            for (int i = 1; i < args.Length; i++)
            {
                switch (args[i].ToLower())
                {
                    case "/v":
                        valueName = args[++i]; // Next argument is the value name
                        break;
                    case "/ve":
                        valueName = ""; // Empty value name for default value
                        break;
                    case "/t":
                        valueType = ParseValueType(args[++i]); // Next argument is the type
                        break;
                    case "/d":
                        valueData = args[++i]; // Next argument is the data
                        break;
                    case "/f":
                        force = true; // Force flag
                        break;
                    default:
                        if (keyPath == null) keyPath = args[i]; // First positional argument is the keyPath
                        break;
                }
            }

            if (keyPath == null)
            {
                throw new ArgumentException("Key path is required.");
            }

            try
            {
                keyPath = NormalizeKeyPath(keyPath);
                using (RegistryKey key = GetBaseRegistryKey(keyPath, writable: true, createSubKey: true))
                {
                    if (key == null)
                    {
                        throw new InvalidOperationException($"Failed to open or create registry key: {keyPath}");
                    }

                    if (valueName != null)
                    {
                        object data = ConvertToRegistryValue(valueType, valueData);

                        if (force || key.GetValue(valueName) == null)
                        {
                            key.SetValue(valueName, data, valueType);
                            DisplaySuccessMessage($"Registry value added: {valueName} = {valueData}");
                        }
                        else
                        {
                            Console.WriteLine($"Registry value already exists: {valueName}. Use /f to force overwrite.");
                        }
                    }
                    else
                    {
                        DisplaySuccessMessage($"Key created: {keyPath}");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"An error occurred: {ex.Message}");
            }
        }

        // IMPORT function
        static void ImportRegistryFile(string filePath)
        {
            try
            {
                if (!File.Exists(filePath))
                {
                    Console.Error.WriteLine($"File not found: {filePath}");
                    return;
                }

                // Detect encoding based on the file content
                Encoding encoding = DetectFileEncoding(filePath);

                using (StreamReader reader = new StreamReader(filePath, encoding))
                {
                    string line;
                    RegistryKey currentKey = null;
                    string accumulatedLine = ""; // To accumulate lines with continuation characters

                    while ((line = reader.ReadLine()) != null)
                    {
                        line = line.Trim();

                        // Skip empty, comment, and header lines
                        if (string.IsNullOrWhiteSpace(line) || line.StartsWith(";") || line.StartsWith("Windows") || line.StartsWith("REGEDIT"))
                            continue;

                        // Handle line continuation (backslash at the end)
                        if (line.EndsWith("\\"))
                        {
                            accumulatedLine += line.Substring(0, line.Length - 1).Trim();
                            continue; // Wait for the next line to continue processing
                        }
                        else
                        {
                            // Accumulate the last part of the line
                            accumulatedLine += line.Trim();
                        }

                        // Now process the complete accumulated line
                        if (accumulatedLine.StartsWith("[") && accumulatedLine.EndsWith("]"))
                        {
                            // It's a key, so we process it as such
                            string keyPath = accumulatedLine.Trim('[', ']');
                            currentKey?.Close();

                            currentKey = CreateOrOpenRegistryKey(keyPath);
                        }
                        else if (currentKey != null)
                        {
                            ParseAndSetRegistryValue(currentKey, accumulatedLine);
                        }

                        accumulatedLine = "";
                    }

                    currentKey?.Close();
                }

                DisplaySuccessMessage($"Successfully imported registry from file: {filePath}");
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Error importing registry: {ex.Message}");
            }
        }

        // Function to detect encoding by reading the byte order mark (BOM) or file content
        static Encoding DetectFileEncoding(string filePath)
        {
            using (FileStream file = new FileStream(filePath, FileMode.Open, FileAccess.Read))
            {
                if (file.Length >= 2)
                {
                    byte[] bom = new byte[2];
                    file.Read(bom, 0, 2);

                    // Check for UTF-16 LE BOM (FF FE)
                    if (bom[0] == 0xFF && bom[1] == 0xFE)
                        return Encoding.Unicode;

                    // Check for UTF-16 BE BOM (FE FF)
                    if (bom[0] == 0xFE && bom[1] == 0xFF)
                        return Encoding.BigEndianUnicode;
                }

                // Default to ANSI (UTF-8 without BOM)
                return Encoding.Default;
            }
        }

        static RegistryKey CreateOrOpenRegistryKey(string keyPath)
        {
            try
            {
                keyPath = NormalizeKeyPath(keyPath);

                int firstSlashIndex = keyPath.IndexOf('\\');
                if (firstSlashIndex == -1)
                {
                    // No subkey exists, just return the base key
                    return GetBaseRegistryKey(keyPath, writable: true, createSubKey: true);
                }

                string baseKeyName = keyPath.Substring(0, firstSlashIndex);
                string subKeyPath = keyPath.Substring(firstSlashIndex + 1);

                // Get the base registry key (e.g., HKEY_CURRENT_USER)
                RegistryKey baseKey = GetBaseRegistryKey(baseKeyName, writable: true, createSubKey: true);
                if (baseKey == null)
                {
                    throw new InvalidOperationException($"Invalid base registry key: {baseKeyName}");
                }

                // Create the subkey path if it doesn't exist
                return CreateSubKeyPath(baseKey, subKeyPath);
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Error creating or opening registry key '{keyPath}': {ex.Message}");
                return null;
            }
        }

        static RegistryKey CreateSubKeyPath(RegistryKey baseKey, string subKeyPath)
        {
            try
            {
                // Recursively create or open each subkey in the path
                RegistryKey currentKey = baseKey.CreateSubKey(subKeyPath, true);
                if (currentKey == null)
                {
                    throw new InvalidOperationException($"Failed to create or open registry subkey: {subKeyPath}");
                }

                return currentKey;
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Error creating subkey path '{subKeyPath}': {ex.Message}");
                return null;
            }
        }

        // EXPORT function
        static void ExportRegistryKey(string keyPath, string filePath, bool forceOverwrite)
        {
            keyPath = NormalizeKeyPath(keyPath);

            try
            {
                if (File.Exists(filePath) && !forceOverwrite)
                {
                    Console.WriteLine($"File {filePath} already exists. Use /y to overwrite.");
                    return;
                }

                using (RegistryKey key = GetBaseRegistryKey(keyPath))
                {
                    if (key == null)
                    {
                        Console.Error.WriteLine($"Registry key not found: {keyPath}");
                        return;
                    }

                    using (StreamWriter writer = new StreamWriter(filePath, false, System.Text.Encoding.Unicode))
                    {
                        writer.WriteLine("Windows Registry Editor Version 5.00\r\n");
                        ExportKey(key, keyPath, writer);
                    }
                    DisplaySuccessMessage($"Registry exported to file: {filePath}");
                }
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Error exporting registry: {ex.Message}");
            }
        }

        static string NormalizeKeyPath(string keyPath)
        {
            // map abbreviations and full names to their full uppercase versions
            var keyMappings = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                { "HKLM", "HKEY_LOCAL_MACHINE" },
                { "HKEY_LOCAL_MACHINE", "HKEY_LOCAL_MACHINE" },
                { "HKCU", "HKEY_CURRENT_USER" },
                { "HKEY_CURRENT_USER", "HKEY_CURRENT_USER" },
                { "HKCR", "HKEY_CLASSES_ROOT" },
                { "HKEY_CLASSES_ROOT", "HKEY_CLASSES_ROOT" },
                { "HKU", "HKEY_USERS" },
                { "HKEY_USERS", "HKEY_USERS" },
                { "HKCC", "HKEY_CURRENT_CONFIG" },
                { "HKEY_CURRENT_CONFIG", "HKEY_CURRENT_CONFIG" }
            };

            string[] pathParts = keyPath.Split(new char[] { '\\' }, 2);

            if (keyMappings.ContainsKey(pathParts[0]))
            {
                pathParts[0] = keyMappings[pathParts[0]];
            }
            return pathParts.Length > 1 ? $"{pathParts[0]}\\{pathParts[1]}" : pathParts[0];
        }

        static void ExportKey(RegistryKey key, string keyPath, StreamWriter writer)
        {
            writer.WriteLine($"[{keyPath}]");
            foreach (string valueName in key.GetValueNames())
            {
                object value = key.GetValue(valueName, null, RegistryValueOptions.DoNotExpandEnvironmentNames);
                RegistryValueKind kind = key.GetValueKind(valueName);
                writer.WriteLine(FormatRegistryValue(valueName, value, kind));
            }
            writer.WriteLine();

            foreach (string subkeyName in key.GetSubKeyNames())
            {
                using (RegistryKey subKey = key.OpenSubKey(subkeyName))
                {
                    if (subKey != null)
                    {
                        ExportKey(subKey, $"{keyPath}\\{subkeyName}", writer);
                    }
                }
            }
        }

        static string FormatRegistryValue(string name, object value, RegistryValueKind kind)
        {
            string formattedName = string.IsNullOrEmpty(name) ? "@" : $"\"{name.Replace("\\", "\\\\").Replace("\"", "\\\"")}\"";

            switch (kind)
            {
                case RegistryValueKind.String:
                    return $"{formattedName}=\"{value.ToString().Replace("\\", "\\\\").Replace("\"", "\\\"")}\"";

                case RegistryValueKind.ExpandString:
                    string hexExpandString = string.Join(",", BitConverter.ToString(Encoding.Unicode.GetBytes(value.ToString())).Split('-'));
                    return $"{formattedName}=hex(2):{hexExpandString}";

                case RegistryValueKind.DWord:
                    return $"{formattedName}=dword:{((uint)(int)value).ToString("x8")}";

                case RegistryValueKind.QWord:
                    ulong qwordValue = Convert.ToUInt64(value);
                    return $"{formattedName}=hex(b):{string.Join(",", BitConverter.GetBytes(qwordValue).Select(b => b.ToString("x2")))}";

                case RegistryValueKind.Binary:
                    return $"{formattedName}=hex:{BitConverter.ToString((byte[])value).Replace("-", ",")}";

                case RegistryValueKind.MultiString:
                    string[] multiStrings = (string[])value;
                    var hexValues = multiStrings.SelectMany(s => Encoding.Unicode.GetBytes(s)
                                                    .Select(b => b.ToString("x2"))
                                                    .Concat(new[] { "00", "00" }))
                                                    .ToList();
                    hexValues.AddRange(new[] { "00", "00" });
                    return $"{formattedName}=hex(7):{string.Join(",", hexValues)}";

                case RegistryValueKind.None:
                    byte[] noneData = value as byte[];
                    string hexNone = string.Join(",", noneData.Select(b => b.ToString("x2")));
                    return $"{formattedName}=hex(0):{hexNone}";

                default:
                    throw new NotSupportedException($"Unsupported registry value type: {kind}");
            }
        }

        static void DeleteRegistryKeyOrValue(string[] args)
        {
            string keyPath = args[1];
            keyPath = NormalizeKeyPath(keyPath);
            string valueName = null;
            bool deleteAllValues = false;
            bool force = args.Contains("/f");

            if (args.Contains("/va"))
            {
                deleteAllValues = true;
            }
            else if (args.Contains("/ve"))
            {
                valueName = ""; // Default value
            }
            else if (args.Contains("/v"))
            {
                valueName = args[Array.IndexOf(args, "/v") + 1];
            }

            try
            {
                string[] keyParts = keyPath.Split(new char[] { '\\' }, 2);
                string root = keyParts[0].ToUpper();
                string subKey = keyParts.Length > 1 ? keyParts[1] : string.Empty;

                using (RegistryKey baseKey = GetBaseRegistryKey(root, writable: true))
                {
                    if (baseKey == null)
                    {
                        throw new ArgumentException($"Could not open the root hive: {root}");
                    }

                    if (!string.IsNullOrEmpty(subKey))
                    {
                        // Open subKey as writable to delete values within it
                        using (RegistryKey targetKey = baseKey.OpenSubKey(subKey, writable: true))
                        {
                            if (targetKey == null)
                            {
                                Console.Error.WriteLine($"ERROR: The system was unable to find the specified registry key or value.");
                                return;
                            }

                            if (!force)
                            {
                                // Determine prompt based on whether deleting a key or a value
                                if (deleteAllValues)
                                {
                                    Console.Write($"Delete all values under the registry key {keyPath} (Yes/No)? ");
                                }
                                else if (valueName != null)
                                {
                                    Console.Write($"Delete the registry value {valueName} (Yes/No)? ");
                                }
                                else
                                {
                                    // Prompt for key deletion
                                    Console.Write($"Permanently delete the registry key {keyPath} (Yes/No)? ");
                                }

                                string response = Console.ReadLine();
                                if (string.IsNullOrEmpty(response) || !response.StartsWith("y", StringComparison.OrdinalIgnoreCase))
                                {
                                    Console.WriteLine("Operation cancelled.");
                                    return;
                                }
                            }

                            if (deleteAllValues)
                            {
                                foreach (var name in targetKey.GetValueNames())
                                {
                                    targetKey.DeleteValue(name, throwOnMissingValue: false);
                                }
                                DisplaySuccessMessage($"All values deleted under key: {keyPath}");
                            }
                            else if (valueName != null)
                            {
                                if (targetKey.GetValue(valueName) != null)
                                {
                                    targetKey.DeleteValue(valueName);
                                    DisplaySuccessMessage($"Deleted value '{valueName}' under key: {keyPath}");
                                }
                                else
                                {
                                    Console.Error.WriteLine($"ERROR: The system was unable to find the specified registry key or value.");
                                }
                            }
                            else
                            {
                                // Delete the entire subKey tree
                                baseKey.DeleteSubKeyTree(subKey, throwOnMissingSubKey: false);
                                DisplaySuccessMessage($"Deleted key: {keyPath}");
                            }
                        }
                    }
                    else
                    {
                        Console.WriteLine("Cannot delete the root hive itself.");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Error deleting registry key or value: {ex.Message}");
            }
        }

        // QUERY function
        static void QueryRegistryKeyOrValue(string[] args)
        {
            string keyPath = args[1];
            keyPath = NormalizeKeyPath(keyPath);
            string valueName = args.Contains("/v") ? args[Array.IndexOf(args, "/v") + 1] : null;
            bool queryDefaultValue = args.Contains("/ve");
            bool isRecursive = args.Contains("/s"); // Check if /s is passed for recursive query
            bool hasValues = false;
            string myKey = @"HKEY_CURRENT_USER\Software\CSReg";
            try { Registry.CurrentUser.OpenSubKey(@"Software\CSReg", true)?.DeleteValue("RetVal", false); } catch { }

            try
            {
                using (RegistryKey key = GetBaseRegistryKey(keyPath))
                {
                    if (key == null)
                    {
                        Console.Error.WriteLine($"ERROR: The system was unable to find the specified registry key or value.");
                        return;
                    }

                    Console.WriteLine(); // Always print one blank line at the start

                    if (valueName != null) // Query a specific value
                    {
                        object value = key.GetValue(valueName, null, RegistryValueOptions.DoNotExpandEnvironmentNames);
                        if (value == null)
                        {
                            Console.Error.WriteLine($"ERROR: The system was unable to find the specified registry key or value.");
                        }
                        else
                        {
                            RegistryValueKind valueKind = key.GetValueKind(valueName);
                            Console.WriteLine(keyPath); // Print the full registry key path
                            Console.WriteLine($"    {valueName}    {FormatRegistryValueType(valueKind)}    {FormatRegistryValueData(value, valueKind)}");
                            Console.WriteLine(); // print blank line
                            Registry.SetValue(myKey, "RetVal", $"{value}", RegistryValueKind.String);
                        }
                    }
                    else if (queryDefaultValue) // Query the default value
                    {
                        object defaultValue = key.GetValue(null, null, RegistryValueOptions.DoNotExpandEnvironmentNames);
                        if (defaultValue != null)
                        {
                            RegistryValueKind defaultValueKind = key.GetValueKind(null);
                            Console.WriteLine(keyPath); // Print the full registry key path
                            Console.WriteLine($"    (Default)    {FormatRegistryValueType(defaultValueKind)}    {FormatRegistryValueData(defaultValue, defaultValueKind)}");
                            Console.WriteLine(); // print blank line
                            Registry.SetValue(myKey, "RetVal", $"{defaultValue}", RegistryValueKind.String);
                        }
                        else
                        {
                            Console.Error.WriteLine($"ERROR: The system was unable to find the specified registry key or value.");
                        }
                    }
                    else
                    {
                        // If recursive, call recursive query method
                        if (isRecursive)
                        {
                            QueryRegistryRecursively(key, keyPath);
                        }
                        else
                        {
                            // Query and print all values
                            foreach (var name in key.GetValueNames())
                            {
                                if (!hasValues)
                                {
                                    Console.WriteLine(keyPath); // Print key path
                                    hasValues = true;
                                }

                                object value = key.GetValue(name, null, RegistryValueOptions.DoNotExpandEnvironmentNames);
                                RegistryValueKind kind = key.GetValueKind(name);

                                string valueNameToPrint = string.IsNullOrEmpty(name) ? "(Default)" : name;
                                Console.WriteLine($"    {valueNameToPrint}    {FormatRegistryValueType(kind)}    {FormatRegistryValueData(value, kind)}");
                            }

                            // Print a blank line after values if any were found
                            if (hasValues) Console.WriteLine();

                            // Query and print subkeys
                            foreach (var subkeyName in key.GetSubKeyNames())
                            {
                                Console.WriteLine($"{keyPath}\\{subkeyName}");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Error querying registry: {ex.Message}");
            }
        }

        // Recursive query method for subkeys and values
        static void QueryRegistryRecursively(RegistryKey key, string keyPath)
        {
            bool hasValues = false;

            // Print values under the current key
            foreach (var name in key.GetValueNames())
            {
                if (!hasValues)
                {
                    Console.WriteLine(keyPath); // Print key path
                    hasValues = true;
                }

                object value = key.GetValue(name, null, RegistryValueOptions.DoNotExpandEnvironmentNames);
                RegistryValueKind kind = key.GetValueKind(name);

                string valueNameToPrint = string.IsNullOrEmpty(name) ? "(Default)" : name;
                Console.WriteLine($"    {valueNameToPrint}    {FormatRegistryValueType(kind)}    {FormatRegistryValueData(value, kind)}");
            }

            // If values were printed, add a blank line after them
            if (hasValues)
            {
                Console.WriteLine();
            }

            // Recurse into subkeys
            foreach (var subkeyName in key.GetSubKeyNames())
            {
                string subkeyPath = $"{keyPath}\\{subkeyName}";
                using (RegistryKey subkey = key.OpenSubKey(subkeyName))
                {
                    if (subkey != null)
                    {
                        QueryRegistryRecursively(subkey, subkeyPath); // Recurse into the subkey
                    }
                }
            }
        }

        static string FormatRegistryValueType(RegistryValueKind kind)
        {
            switch (kind)
            {
                case RegistryValueKind.String: return "REG_SZ";
                case RegistryValueKind.ExpandString: return "REG_EXPAND_SZ";
                case RegistryValueKind.DWord: return "REG_DWORD";
                case RegistryValueKind.QWord: return "REG_QWORD";
                case RegistryValueKind.Binary: return "REG_BINARY";
                case RegistryValueKind.MultiString: return "REG_MULTI_SZ";
                case RegistryValueKind.None: return "REG_NONE";
                default: return "UNKNOWN_TYPE";
            }
        }

        static string FormatRegistryValueData(object value, RegistryValueKind kind)
        {
            switch (kind)
            {
                case RegistryValueKind.String:
                case RegistryValueKind.ExpandString:
                    return value.ToString();

                case RegistryValueKind.DWord:
                    return "0x" + ((uint)(int)value).ToString("x");

                case RegistryValueKind.QWord:
                    return "0x" + ((ulong)(long)value).ToString("x");

                case RegistryValueKind.Binary:
                    return BitConverter.ToString((byte[])value).Replace("-", "");

                case RegistryValueKind.MultiString:
                    return string.Join("\\0", (string[])value);

                case RegistryValueKind.None:
                    return ""; // No data for REG_NONE

                default:
                    throw new NotSupportedException($"Unsupported registry value type: {kind}");
            }
        }

        static RegistryKey GetBaseRegistryKey(string keyPath, bool writable = false, bool createSubKey = false)
        {
            string[] keyParts = keyPath.Split(new char[] { '\\' }, 2); // Split into root and subkey
            string root = keyParts[0].ToUpper();
            string subKey = keyParts.Length > 1 ? keyParts[1] : string.Empty; // If there's no subkey, handle it as empty

            RegistryKey baseKey;

            switch (root)
            {
                case "HKEY_LOCAL_MACHINE":
                    baseKey = Registry.LocalMachine;
                    break;
                case "HKEY_CURRENT_USER":
                    baseKey = Registry.CurrentUser;
                    break;
                case "HKEY_CLASSES_ROOT":
                    baseKey = Registry.ClassesRoot;
                    break;
                case "HKEY_USERS":
                    baseKey = Registry.Users;
                    break;
                case "HKEY_CURRENT_CONFIG":
                    baseKey = Registry.CurrentConfig;
                    break;
                default:
                    throw new NotSupportedException($"Unsupported root key: {root}");
            }

            if (string.IsNullOrEmpty(subKey)) return baseKey;

            if (createSubKey)
            {
                return baseKey.CreateSubKey(subKey, writable);
            }
            else
            {
                return baseKey.OpenSubKey(subKey, writable);
            }
        }

        static RegistryValueKind ParseValueType(string type)
        {
            switch (type.ToUpper())
            {
                case "REG_SZ":
                    return RegistryValueKind.String;
                case "REG_MULTI_SZ":
                    return RegistryValueKind.MultiString;
                case "REG_EXPAND_SZ":
                    return RegistryValueKind.ExpandString;
                case "REG_DWORD":
                    return RegistryValueKind.DWord;
                case "REG_QWORD":
                    return RegistryValueKind.QWord;
                case "REG_BINARY":
                    return RegistryValueKind.Binary;
                case "REG_NONE":
                    return RegistryValueKind.None;
                default:
                    throw new NotSupportedException($"Unsupported registry value type: {type}");
            }
        }

        static object ConvertToRegistryValue(RegistryValueKind kind, string data)
        {
            switch (kind)
            {
                case RegistryValueKind.String:
                case RegistryValueKind.ExpandString:
                    return data;

                case RegistryValueKind.DWord:
                    return Convert.ToUInt32(data, 16);

                case RegistryValueKind.QWord:
                    return Convert.ToUInt64(data, 16);

                case RegistryValueKind.MultiString:
                    return data.Split(new[] { "\\0" }, StringSplitOptions.None);

                case RegistryValueKind.Binary:
                    return Enumerable.Range(0, data.Length / 2).Select(x => Convert.ToByte(data.Substring(x * 2, 2), 16)).ToArray();

                case RegistryValueKind.None:
                    return Encoding.Unicode.GetBytes(data + '\0');

                default:
                    throw new NotSupportedException($"Unsupported registry value kind: {kind}");
            }
        }

        static void ParseAndSetRegistryValue(RegistryKey key, string line)
        {
            string name; string valueData; bool empty;

            void GetNameAndData(string pattern)
            {
                string[] parts = line.Split(new string[] { pattern }, 2, StringSplitOptions.None);
                name = parts[0].Substring(1).Replace("\\\"", "\"").Replace("\\\\", "\\");
                if (name == "@") name = null;
                valueData = parts[1].Substring(0, parts[1].Length);
                if (valueData.EndsWith("\"")) valueData = valueData.Substring(0, valueData.Length - 1);
                valueData = valueData.Replace("\\\"", "\"").Replace("\\\\", "\\");
                empty = valueData.Length == 0;
            }

            void TrimThis(string pattern)
            {
                if (valueData.EndsWith(pattern)) valueData = valueData.Substring(0, valueData.Length - pattern.Length);
                if (valueData == "00,00") valueData = "";
                empty = valueData.Length == 0;
            }

            if (line.StartsWith("@="))
            {
                line = $"\"@\"{line.Substring(1)}";
            }

            string regType = string.Empty;

            if (line.Contains("\"=\"")) regType = "REG_SZ";
            else if (line.Contains("\"=dword:")) regType = "REG_DWORD";
            else if (line.Contains("\"=hex(b):")) regType = "REG_QWORD";
            else if (line.Contains("\"=hex:")) regType = "REG_BINARY";
            else if (line.Contains("\"=hex(2):")) regType = "REG_EXPAND_SZ";
            else if (line.Contains("\"=hex(7):")) regType = "REG_MULTI_SZ";
            else if (line.Contains("\"=hex(0):")) regType = "REG_NONE";

            switch (regType)
            {
                case "REG_SZ":
                    GetNameAndData("\"=\"");
                    key.SetValue(name, valueData, RegistryValueKind.String);
                    break;

                case "REG_DWORD":
                    GetNameAndData("\"=dword:");
                    uint dwordValue = Convert.ToUInt32(valueData, 16);
                    key.SetValue(name, (int)dwordValue, RegistryValueKind.DWord);
                    break;

                case "REG_QWORD":
                    GetNameAndData("\"=hex(b):");
                    string[] bytePairs = valueData.Split(new[] { ',' });
                    ulong qwordValue = 0;
                    for (int i = 0; i < bytePairs.Length; i++)
                    {
                        qwordValue |= ((ulong)Convert.ToByte(bytePairs[i], 16)) << (i * 8);
                    }
                    key.SetValue(name, qwordValue, RegistryValueKind.QWord);
                    break;

                case "REG_BINARY":
                    GetNameAndData("\"=hex:");
                    if (empty)
                    {
                        key.SetValue(name, new byte[0], RegistryValueKind.Binary);
                    }
                    else
                    {
                        byte[] binaryData = valueData.Split(',').Select(h => Convert.ToByte(h, 16)).ToArray();
                        key.SetValue(name, binaryData, RegistryValueKind.Binary);
                    }
                    break;

                case "REG_EXPAND_SZ":
                    GetNameAndData("\"=hex(2):");
                    TrimThis(",00,00");
                    TrimThis(",00,00");

                    if (empty)
                    {
                        key.SetValue(name, string.Empty, RegistryValueKind.ExpandString);
                    }
                    else
                    {
                        byte[] binaryData = valueData.Split(',').Select(h => Convert.ToByte(h, 16)).ToArray();
                        string expandSzValue = Encoding.Unicode.GetString(binaryData);
                        key.SetValue(name, expandSzValue, RegistryValueKind.ExpandString);
                    }
                    break;

                case "REG_MULTI_SZ":
                    GetNameAndData("\"=hex(7):");
                    TrimThis(",00,00");
                    TrimThis(",00,00");

                    if (empty)
                    {
                        key.SetValue(name, new string[] { string.Empty }, RegistryValueKind.MultiString);
                    }
                    else
                    {
                        byte[] binaryData = valueData.Split(',').Select(h => Convert.ToByte(h, 16)).ToArray();
                        string multiSzValue = Encoding.Unicode.GetString(binaryData);
                        string[] multiStringArray = multiSzValue.Split(new[] { '\0' });
                        key.SetValue(name, multiStringArray, RegistryValueKind.MultiString);
                    }
                    break;

                case "REG_NONE":
                    GetNameAndData("\"=hex(0):");
                    if (empty)
                    {
                        key.SetValue(name, Encoding.Unicode.GetBytes("" + '\0'), RegistryValueKind.None);
                    }
                    else
                    {
                        byte[] binaryData = valueData.Split(',').Select(h => Convert.ToByte(h, 16)).ToArray();
                        key.SetValue(name, binaryData, RegistryValueKind.None);
                    }
                    break;

                default:
                    throw new InvalidOperationException("Unknown registry value type.");
            }
        }
    }
}
