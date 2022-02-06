#include <iostream>
#include <windows.h>
#include <vector>
#include <atlstr.h>
#include <atlimage.h>
#include <fstream>

using namespace std;

void TakeScreenShot(const std::string& path)
{
    //setting to the screen shot
    keybd_event(VK_SNAPSHOT, 0x45, KEYEVENTF_EXTENDEDKEY, 0);
    keybd_event(VK_SNAPSHOT, 0x45, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP, 0);

    //handler of the bitmap that save the screen shot
    HBITMAP hBitmap;

    //I have to give for it time to make it work
    Sleep(100);

    //take the screen shot
    OpenClipboard(NULL);

    //save the screen shot in the bitmap handler 
    hBitmap = (HBITMAP)GetClipboardData(CF_BITMAP);

    //relese the screen shot
    CloseClipboard();

    std::vector<BYTE> buf;
    IStream *stream = NULL;
    HRESULT hr = CreateStreamOnHGlobal(0, TRUE, &stream);
    CImage image;
    ULARGE_INTEGER liSize;

    // screenshot to PNG and save to stream
    image.Attach(hBitmap);
    image.Save(stream, Gdiplus::ImageFormatPNG);
    IStream_Size(stream, &liSize);
    DWORD len = liSize.LowPart;
    IStream_Reset(stream);
    buf.resize(len);
    IStream_Read(stream, &buf[0], len);
    stream->Release();
    // put the imapge in the file
    std::fstream fi;
    fi.open(path, std::fstream::binary | std::fstream::out);
    fi.write(reinterpret_cast<const char*>(&buf[0]), buf.size() * sizeof(BYTE));
    fi.close();
}

int main() //ah, comments, my favorite
{
	char* env = getenv("TEMP");
	std::cout << env;
    TakeScreenShot((std::string(env)) + "/IAMFORTNITEGAMERHACKER.png");
}