if(WIN32)
    cmake_path(GET CMAKE_CURRENT_LIST_DIR STEM PROJ)
    set(CMAKE_INCLUDE_CURRENT_DIR ON)

    set(SOURCES utils.i)
    set_property(SOURCE ${SOURCES} 
    PROPERTY CPLUSPLUS ON)
    set_property(SOURCE ${SOURCES} PROPERTY SWIG_MODULE_NAME ${PROJ})
    set_property(SOURCE ${SOURCES}
    PROPERTY COMPILE_OPTIONS
    "-interface" "${PROJ}"
    "-module" "${PROJ}"
    "-DUNICODE"
    "-builtin"
    # "-debug-tmused"
    # "-debug-tmsearch"
    # "-directors"
    # "-oh" "${PROJ}.h"
    )

    if(MODULE_NAME STREQUAL PROJ)
        set(${PROJ}_FLAG TYPE STATIC)
    endif()

    swig_add_library(${PROJ} LANGUAGE python ${${PROJ}_FLAG} SOURCES ${SOURCES})
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
endif()