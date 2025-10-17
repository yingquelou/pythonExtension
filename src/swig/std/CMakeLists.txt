cmake_path(GET CMAKE_CURRENT_LIST_DIR STEM PROJ)
set(${PROJ}_SOURCES std.i)
set_property(SOURCE ${${PROJ}_SOURCES} PROPERTY
CPLUSPLUS ON)
set_property(SOURCE ${${PROJ}_SOURCES} 
PROPERTY COMPILE_OPTIONS
"-builtin"
"-interface" "${PROJ}"
"-module" "${PROJ}"
# "-debug-tmused"
# "-debug-typemap"
# "-debug-tmsearch"
# "-directors"
)
if(MODULE_NAME STREQUAL PROJ)
    set(${PROJ}_FLAG TYPE STATIC)
endif()
swig_add_library(${PROJ} LANGUAGE python ${${PROJ}_FLAG} SOURCES ${${PROJ}_SOURCES})
target_link_libraries(${PROJ} Python::Python)
if(MSVC)
    set(DEBUG_FLAG _d)
endif()

set_target_properties(${PROJ} PROPERTIES
DEBUG_POSTFIX "${DEBUG_FLAG}.${Python_SOABI}"
PREFIX "")
target_compile_definitions(${PROJ} PRIVATE
UNICODE
# Py_LIMITED_API=0x03080af0
)
swig_test()