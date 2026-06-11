using System;
using System.Runtime.InteropServices;
using System.IO;
using System.Collections.Generic;

namespace GetMoreProperties
{
    internal class Program
    {
        static void Main()
        {
            string tempPath = Path.GetTempPath();
            string filePath = Path.Combine(tempPath, "Properties.tmp");

            List<string> matchingProperties = new List<string>();

            PSEnumeratePropertyDescriptions(PROPDESC_ENUMFILTER.PDEF_ALL, typeof(IPropertyDescriptionList).GUID, out var list);
            for (var i = 0; i < list.GetCount(); i++)
            {
                var pd = list.GetAt(i, typeof(IPropertyDescription).GUID);

                pd.GetDisplayName(out var p);
                if (p != IntPtr.Zero)
                {
                    var viewable = pd.GetTypeFlags(PROPDESC_TYPE_FLAGS.PDTF_ISVIEWABLE) == PROPDESC_TYPE_FLAGS.PDTF_ISVIEWABLE;

                    if (viewable)
                    {
                        string dname = Marshal.PtrToStringUni(p);
                        Marshal.FreeCoTaskMem(p);

                        pd.GetCanonicalName(out p);
                        string cname = Marshal.PtrToStringUni(p);
                        Marshal.FreeCoTaskMem(p);

                        if (!cname.StartsWith("System") && !cname.StartsWith("Icaros"))
                        {
                            matchingProperties.Add($"{dname};.{cname}");
                        }
                    }
                }
            }

            if (matchingProperties.Count > 0)
            {
                using (StreamWriter writer = new StreamWriter(filePath, false, System.Text.Encoding.Unicode))
                {
                    foreach (var property in matchingProperties)
                    {
                        writer.WriteLine(property);
                    }
                }
            }
        }

        public struct PROPERTYKEY
        {
            public Guid fmtid;
            public int pid;
        }

        public enum PROPDESC_ENUMFILTER
        {
            PDEF_ALL = 0,
            PDEF_SYSTEM = 1,
            PDEF_NONSYSTEM = 2,
            PDEF_VIEWABLE = 3,
            PDEF_QUERYABLE = 4,
            PDEF_INFULLTEXTQUERY = 5,
            PDEF_COLUMN = 6,
        }

        [Flags]
        public enum PROPDESC_TYPE_FLAGS
        {
            PDTF_DEFAULT = 0,
            PDTF_MULTIPLEVALUES = 0x1,
            PDTF_ISINNATE = 0x2,
            PDTF_ISGROUP = 0x4,
            PDTF_CANGROUPBY = 0x8,
            PDTF_CANSTACKBY = 0x10,
            PDTF_ISTREEPROPERTY = 0x20,
            PDTF_INCLUDEINFULLTEXTQUERY = 0x40,
            PDTF_ISVIEWABLE = 0x80,
            PDTF_ISQUERYABLE = 0x100,
            PDTF_CANBEPURGED = 0x200,
            PDTF_SEARCHRAWVALUE = 0x400,
            PDTF_DONTCOERCEEMPTYSTRINGS = 0x800,
            PDTF_ALWAYSINSUPPLEMENTALSTORE = 0x1000,
            PDTF_ISSYSTEMPROPERTY = unchecked((int)0x80000000),
            PDTF_MASK_ALL = unchecked((int)0x80001fff),
        }

        [DllImport("propsys")]
        public static extern int PSEnumeratePropertyDescriptions(PROPDESC_ENUMFILTER filterOn, [MarshalAs(UnmanagedType.LPStruct)] Guid riid, out IPropertyDescriptionList ppv);

        [ComImport, Guid("1F9FC1D0-C39B-4B26-817F-011967D3440E"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        public interface IPropertyDescriptionList
        {
            int GetCount();
            [return: MarshalAs(UnmanagedType.Interface)]
            IPropertyDescription GetAt(int iElem, [MarshalAs(UnmanagedType.LPStruct)] Guid riid);
        }

        [ComImport, Guid("6F79D558-3E96-4549-A1D1-7D75D2288814"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        public interface IPropertyDescription
        {
            PROPERTYKEY GetPropertyKey();
            [PreserveSig] int GetCanonicalName(out IntPtr zPtr);
            int GetPropertyType();
            [PreserveSig] int GetDisplayName(out IntPtr zPtr);
            [PreserveSig] int GetEditInvitation(out IntPtr zPtr);
            PROPDESC_TYPE_FLAGS GetTypeFlags(PROPDESC_TYPE_FLAGS mask);
        }
    }
}
