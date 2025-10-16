if(WIN32)
    cmake_path(GET CMAKE_CURRENT_LIST_DIR STEM PROJ)
    set(CMAKE_INCLUDE_CURRENT_DIR ON)

    set_property(SOURCE utils.i 
    PROPERTY COMPILE_OPTIONS 
    "-module" "${PROJ}"
    # "-debug-tmused"
    # "-debug-tmsearch"
    # "-directors"
    # "-oh" "ok.h"
    )

    if(MODULE_NAME STREQUAL PROJ)
        set(${PROJ}_FLAG NO_PROXY TYPE STATIC)
    endif()

    swig_add_python_library(${PROJ} ${${PROJ}_FLAG} utils.i)
    
    target_compile_definitions(${PROJ} PRIVATE
    UNICODE
    # Py_LIMITED_API=0x03080af0
    )

    swig_test()
endif()