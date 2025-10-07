cmake_policy(PUSH)
cmake_policy(SET CMP0078 NEW)
cmake_policy(SET CMP0086 NEW)
cmake_path(GET CMAKE_CURRENT_LIST_DIR STEM PROJ)
find_package(SWIG REQUIRED)
include(UseSWIG)

set_property(SOURCE utils.i PROPERTY
CPLUSPLUS ON)

set_property(SOURCE utils.i 
PROPERTY COMPILE_OPTIONS 
"-module" "${PROJ}"
# "-directors"
# "-oh" "ok.h"
)
if(WIN32)
    set(${PROJ}_SUFFIX pyd)
else()
    set(${PROJ}_SUFFIX so)
endif()

swig_add_library(${PROJ} 
NO_PROXY
LANGUAGE python SOURCES utils.i)
set_target_properties(${PROJ} PROPERTIES
SUFFIX ".${Python_SOABI}.${${PROJ}_SUFFIX}"
DEBUG_POSTFIX "_d"
)
target_link_libraries(${PROJ} Python::Python)
cmake_policy(POP)

add_test(NAME ${PROJ} COMMAND py .
WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
set_tests_properties(${PROJ} PROPERTIES ENVIRONMENT_MODIFICATION PYTHONPATH=path_list_prepend:$<TARGET_FILE_DIR:${PROJ}>)