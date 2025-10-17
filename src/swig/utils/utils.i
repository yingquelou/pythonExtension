%{
    #include <win32.h>
%}
%feature("autodoc",2);

#ifdef UNICODE
%include "cwstring.i"
typedef wchar_t OLECHAR;
#else
%include "cstring.i"
typedef char OLECHAR;
#endif
typedef OLECHAR *BSTR;
typedef OLECHAR *LPOLESTR;
typedef const OLECHAR *LPCOLESTR;
typedef GUID IID;
typedef GUID CLSID;
typedef CLSID *LPCLSID;

%typemap(argout) OLECHAR * {
    $result = PyUnicode_FromWideChar($1,-1);
}

%typemap(in,numinputs=0) GUID *ArgOut (GUID temp){
    $1 = &temp;
}

%typemap(argout) GUID * {
    wchar_t *guid;
    #ifdef __cplusplus
    #define REFCLSID const IID &
        StringFromCLSID(*$1, &guid);
    #else
    #define REFCLSID const IID * __MIDL_CONST
        StringFromCLSID($1, &guid);
    #endif
    $result = PyUnicode_FromWideChar(guid, -1);
}

%typemap(in) GUID * (GUID temp) {
    $1 = &temp;
    Py_ssize_t sz;
    CLSIDFromString(PyUnicode_AsWideCharString($input,&sz),$1);
}

%typemap(in) GUID& (GUID temp) {
    $1 = &temp;
    Py_ssize_t sz;
    CLSIDFromString(PyUnicode_AsWideCharString($input,&sz),$1);
}

%typemap(in,numinputs=0) OLECHAR **ArgOut (OLECHAR * temp) {
    $1 = &temp;
}

%typemap(argout) OLECHAR ** {
    $result = PyUnicode_FromWideChar(*($1), -1);
}

%init {
    // Add an integer constant 'name' with value 12 to the Python module
    PyModule_AddIntConstant(m,"name",12);
}


%apply GUID *ArgOut {LPCLSID lpclsid}
HRESULT CLSIDFromProgID(LPCOLESTR lpszProgID, LPCLSID lpclsid);

%apply OLECHAR **ArgOut {LPOLESTR *lplpszProgID}
HRESULT ProgIDFromCLSID(REFCLSID clsid, LPOLESTR *lplpszProgID);
