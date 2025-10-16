#ifdef MODULE_NAME
%module MODULE_NAME
#endif
%include "std_vector.i" 
%include "std_array.i" 
// %include "std_iostream.i" 
%include "std_complex.i" 
%include "cstring.i" 

namespace std {
    %template("vector") vector<PyObject*>;
};
