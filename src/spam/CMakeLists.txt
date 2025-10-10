if(WIN32)
    cmake_path(GET CMAKE_CURRENT_LIST_DIR STEM PROJ)

    if(MODULE_NAME STREQUAL PROJ)
        set(${PROJ}_FLAG STATIC)
    else()
        set(${PROJ}_FLAG WITH_SOABI)
    endif()
    python_add_library(${PROJ} ${${PROJ}_FLAG} spam.cpp)
    target_compile_definitions(${PROJ}
    PRIVATE
    __MODULE_NAME__="${PROJ}"
    "PyInit_MODULE=PyInit_${PROJ}"
    )
    if(MSVC)
        set_target_properties(${PROJ} PROPERTIES CXX_STANDARD 20)
    endif()
    python_test()
endif()