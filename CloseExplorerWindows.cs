using System;
using System.Runtime.InteropServices;

class Program
{
    // Import the necessary Windows API functions
    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool PostMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    // Message constants
    const uint WM_CLOSE = 0x0010;

    static void Main()
    {
        // Look for windows with the class name "CabinetWClass" (Explorer windows)
        IntPtr hWnd = FindWindow("CabinetWClass", null);

        // Loop to find and close all open Explorer windows
        while (hWnd != IntPtr.Zero)
        {
            try
            {
                // Check if the window is visible
                if (IsWindowVisible(hWnd))
                {
                    // Send the WM_CLOSE message to close the window
                    PostMessage(hWnd, WM_CLOSE, IntPtr.Zero, IntPtr.Zero);
                    Console.WriteLine("Closed an Explorer window");
                }

                // Find the next Explorer window
                hWnd = FindWindowEx(IntPtr.Zero, hWnd, "CabinetWClass", null);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error closing window: {ex.Message}");
            }
        }
    }

    // Import FindWindowEx to get the next window of the same class
    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);
}
