// %include "std_wstring.i"
%include "std_string.i"
%include "cwstring.i"
// %include "wchar.i"
%{
#include <sstream>
%} 
%inline {
    const wchar_t *tow()
    {
        return L"NULL";
    }
    struct Point
    {
        double x,y;
    };
}
%extend Point {
    %pythoncode {
        def ok(self):
            return f'Point({self.x,self.y})'
    }
}