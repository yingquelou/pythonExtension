cmake_path(GET CMAKE_CURRENT_LIST_DIR STEM PROJ)
add_executable(${PROJ} main.cpp)
target_link_libraries(${PROJ}
Python::Python ${MODULE_NAME})
execute_process(COMMAND
${Python_EXECUTABLE} -c "import sys;print(sys.exec_prefix)"
OUTPUT_VARIABLE EXEC_PREFIX)
string(STRIP ${EXEC_PREFIX} EXEC_PREFIX)
cmake_path(CONVERT ${EXEC_PREFIX} TO_CMAKE_PATH_LIST EXEC_PREFIX)
target_compile_definitions(${PROJ}
PRIVATE PYTHON_EXEC_PREFIX="${EXEC_PREFIX}")

if(MODULE_NAME)
    target_compile_definitions(${PROJ}
    PRIVATE
    __MODULE_NAME__="${MODULE_NAME}"
    "PyInit_MODULE=PyInit_${MODULE_NAME}")
endif()
