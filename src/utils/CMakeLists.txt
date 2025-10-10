if(WIN32)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0078 NEW)
    cmake_policy(SET CMP0086 NEW)
    cmake_path(GET CMAKE_CURRENT_LIST_DIR STEM PROJ)
    find_package(SWIG REQUIRED)
    include(UseSWIG)
    set(CMAKE_INCLUDE_CURRENT_DIR ON)

    set_property(SOURCE utils.i PROPERTY
    CPLUSPLUS ON)

    set_property(SOURCE utils.i 
    PROPERTY COMPILE_OPTIONS 
    "-module" "${PROJ}"
    "-debug-tmused"
    # "-debug-tmsearch"
    # "-directors"
    # "-oh" "ok.h"
    )

    if(MODULE_NAME STREQUAL PROJ)
        set(${PROJ}_FLAG TYPE STATIC)
    endif()

    swig_add_library(${PROJ} ${${PROJ}_FLAG}
    NO_PROXY
    LANGUAGE python SOURCES utils.i)

    if(MSVC)
    set_target_properties(${PROJ} PROPERTIES
    # SUFFIX ".${Python_SOABI}.${${PROJ}_SUFFIX}"
    DEBUG_POSTFIX _d
    )
    endif()

    target_link_libraries(${PROJ} Python::Python)
    target_compile_definitions(${PROJ} PRIVATE
    UNICODE)
    cmake_policy(POP)

    python_test()
endif()