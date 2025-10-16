cmake_path(GET CMAKE_CURRENT_LIST_DIR STEM PROJ)
set(${PROJ}_SOURCES std.i)
set_property(SOURCE ${${PROJ}_SOURCES} PROPERTY
CPLUSPLUS ON)
set_property(SOURCE ${${PROJ}_SOURCES} 
PROPERTY COMPILE_OPTIONS
"-DMODULE_NAME=${PROJ}"
# "-debug-tmused"
# "-debug-tmsearch"
# "-directors"
)
if(MODULE_NAME STREQUAL PROJ)
    set(${PROJ}_FLAG NO_PROXY TYPE STATIC)
endif()
swig_add_python_library(${PROJ} ${${PROJ}_FLAG} ${${PROJ}_SOURCES})
target_compile_definitions(${PROJ} PRIVATE
UNICODE
# Py_LIMITED_API=0x03080af0
)
swig_test()