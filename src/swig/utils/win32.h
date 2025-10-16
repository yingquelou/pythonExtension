#ifndef WIN32_H
#define WIN32_H 1
#include <windows.h>
#include <string>
namespace win32 {
    using string=std::basic_string<TCHAR>;
};
#endif