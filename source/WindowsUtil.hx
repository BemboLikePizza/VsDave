package;

#if windows
@:cppFileCode('#include <stdlib.h>
#include <stdio.h>
#include <windows.h>
#include <dwmapi.h>
#include <iostream>
#include <string>

#pragma comment(lib, "Dwmapi")')
#end
class WindowsUtil
{
    #if windows
	@:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) | WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(1, 1, 1), 0, LWA_COLORKEY);
        }
    ')
    #end
	static public function getWindowsTransparent(res:Int = 0)
	{
		return res;
	}

    #if windows
	@:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) ^ WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(1, 1, 1), 1, LWA_COLORKEY);
        }
    ')
    #end
	static public function getWindowsbackward(res:Int = 0)
	{
		return res;
	}

    #if windows
    @:functionCode('
        std::string p(getenv("APPDATA"));
        p.append("\\\\Microsoft\\\\Windows\\\\Themes\\\\TranscodedWallpaper");

        SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, (PVOID)p.c_str(), SPIF_UPDATEINIFILE);
    ')
    #end
    static public function updateWallpaper() {
        return null;
    }
}

/**@:functionCode('
([DllImport("user32.dll", EntryPoint="SetWindowLongPtr")]
  private static extern IntPtr
SetWindowLongPtr64(IntPtr, hWnd, int nIndex, IntPtr dwNewLong);

[DllImport("user32.dll")]   
public static extern bool
setLayeredWindowAttributes(IntPtr hwnd, uint crKey, byte bAlpha, uint dwFlags);
void main()
{
  SetWindowLong32(_windown.Handle, -20, 0x00080000);

    SetLayeredWindowAttributes(_window.Handle, 0, 0, 0x00000001);
}
')**/
