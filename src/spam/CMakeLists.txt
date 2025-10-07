cmake_path(GET CMAKE_CURRENT_LIST_DIR STEM PROJ)

python_add_library(${PROJ} WITH_SOABI spam.cpp)
target_compile_definitions(${PROJ}
PRIVATE
__MODULE_NAME__="${PROJ}"
"PyInit_MODULE=PyInit_${PROJ}"
)
if(MSVC)
    set_target_properties(${PROJ} PROPERTIES CXX_STANDARD 20)
endif()


add_test(NAME ${PROJ} COMMAND py .
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
set_tests_properties(${PROJ} PROPERTIES ENVIRONMENT_MODIFICATION PYTHONPATH=path_list_prepend:$<TARGET_FILE_DIR:${PROJ}>)