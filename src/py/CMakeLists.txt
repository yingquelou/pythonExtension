cmake_path(GET CMAKE_CURRENT_LIST_DIR STEM PROJ)
add_executable(${PROJ} main.cpp)
target_link_libraries(${PROJ} PRIVATE Python::Python ${MODULE_NAME})

if(MODULE_NAME)
    target_compile_definitions(${PROJ}
    PRIVATE
    __MODULE_NAME__="${MODULE_NAME}"
    "PyInit_MODULE=PyInit_${MODULE_NAME}")
endif()
