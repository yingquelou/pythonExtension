%{
    #include <Windows.h>
    BSTR demo(HRESULT hr){
    BSTR s;
    FormatMessageW(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
                    NULL, GetLastError(), MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPWSTR)&s, 0, NULL);
    return s;
    }
%}

typedef OLECHAR *BSTR;
typedef OLECHAR *LPOLESTR;
typedef const OLECHAR *LPCOLESTR;
typedef GUID CLSID;
typedef CLSID *LPCLSID;
%typemap(out) OLECHAR * {
    // typemap1
    $result = PyUnicode_FromWideChar($1,-1);
    // SysFreeString($1);
}
%typemap(in) OLECHAR * {
    // typemap2
    Py_ssize_t sz;
    $1 = PyUnicode_AsWideCharString($input,&sz);
    $1=SysAllocStringLen($1,PyLong_AsUnsignedLong(PyLong_FromSsize_t(sz)));
    }
    %typemap(argout) OLECHAR * ARGOUT {
    // typemap4
    $result  = PyUnicode_FromWideChar($1,-1);
    }
    %typemap(in,numinputs=0) LPCLSID lpclsid (CLSID temp){
    // $result , $1 ,$temp
    $1 = &temp;
}
%typemap(argout) LPCLSID lpclsid {
    // typemap5
    wchar_t *guid;
    #ifdef __cplusplus
    #define REFCLSID const IID &
    StringFromCLSID(*$1, &guid);
    #else
    #define REFCLSID const IID * __MIDL_CONST
    StringFromCLSID($1, &guid);
    #endif
    $result = PyUnicode_FromWideChar(guid, -1);
    CoTaskMemFree(guid);
}
#ifdef __cplusplus
#define REFCLSID const IID &
#else
#define REFCLSID const IID * __MIDL_CONST
#endif
%typemap(in) REFCLSID clsid (CLSID temp) {
    $1 = &temp;
    Py_ssize_t sz;
    CLSIDFromString(PyUnicode_AsWideCharString($input,&sz),$1);
}

%typemap(in,numinputs=0) LPOLESTR *lplpszProgID (BSTR temp) {
    // $result , $1
    $1 = &temp;
}

%typemap(argout) LPOLESTR *lplpszProgID {
    if(*($1))
    {$result = PyUnicode_FromWideChar(*($1), -1);}
    else
    { PyErr_SetObject(PyExc_RuntimeError,PyUnicode_FromWideChar(demo(GetLastError()),-1));
        $result = NULL;
    }
}
%feature("autodoc", "1");
HRESULT CLSIDFromProgID(LPCOLESTR lpszProgID, LPCLSID lpclsid);
%feature("autodoc","ProgIDFromCLSID(clsid:str)->str");
HRESULT ProgIDFromCLSID(REFCLSID clsid, LPOLESTR *lplpszProgID);