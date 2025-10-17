function(swig_test)
    add_test(NAME ${PROJ} COMMAND Python::InterpreterMultiConfig ${CMAKE_CURRENT_LIST_DIR})
    set_tests_properties(${PROJ} PROPERTIES 
    ENVIRONMENT PYTHONPATH=${CMAKE_CURRENT_BINARY_DIR}
    ENVIRONMENT_MODIFICATION PYTHONPATH=path_list_prepend:$<TARGET_FILE_DIR:${PROJ}>
    WORKING_DIRECTORY $<TARGET_FILE_DIR:${PROJ}>)
endfunction()
function(list_unique RESULT)
    foreach(ITEM IN LISTS ARGN ${RESULT})
        if(NOT ITEM IN_LIST ${CMAKE_CURRENT_FUNCTION}_OUT)
            list(APPEND ${CMAKE_CURRENT_FUNCTION}_OUT ${ITEM})
        endif()
    endforeach()
    set(${RESULT} ${${CMAKE_CURRENT_FUNCTION}_OUT} PARENT_SCOPE)
endfunction()

function(swig_add_python_library TARGET)
    set(OPTIONS NO_PROXY)
    set(ENTRY
    TYPE # Target Type
    )
    set(ENTRIES
    SWIG_EXTENSIONS # Swig source file extension
    )
    cmake_parse_arguments(PARSE_ARGV 1 ${TARGET} "${OPTIONS}" "${ENTRY}" "${ENTRIES}")

    set(SOURCES ${${TARGET}_UNPARSED_ARGUMENTS})
    set(SWIG_SOURCES ${SOURCES})

    list(APPEND ${TARGET}_SWIG_EXTENSIONS i swig)

    list(TRANSFORM ${TARGET}_SWIG_EXTENSIONS TOLOWER)
    list_unique(${TARGET}_SWIG_EXTENSIONS ${${TARGET}_SWIG_EXTENSIONS})
    list(JOIN ${TARGET}_SWIG_EXTENSIONS "|" SWIG_EXTENSIONS)
    string(JOIN "" SWIG_FILTER ".*\.(" ${SWIG_EXTENSIONS} ")$")
    list(FILTER SOURCES EXCLUDE REGEX ${SWIG_FILTER})
    list(FILTER SWIG_SOURCES INCLUDE REGEX ${SWIG_FILTER})
    if(${TARGET}_NO_PROXY)
        set(SWIG_NO_PROXY -noproxy)
    endif()

    foreach(ITEM IN LISTS SWIG_SOURCES)
        get_property(OPTIONS SOURCE ${ITEM} PROPERTY COMPILE_OPTIONS)
        cmake_path(GET ITEM STEM BASE_FILENAME)
        set(OUTPUT_NAME ${BASE_FILENAME}.py.cpp)
        cmake_path(ABSOLUTE_PATH ITEM)
        
        add_custom_command(OUTPUT ${OUTPUT_NAME} COMMAND
        ${SWIG_EXECUTABLE} -python -c++ ${SWIG_NO_PROXY} ${OPTIONS} -o ${OUTPUT_NAME} ${ITEM}
        MAIN_DEPENDENCY ${ITEM})

        list(APPEND SWIG_GENERATED_SOURCES ${OUTPUT_NAME})
    endforeach()
    python_add_library(${TARGET} ${${TARGET}_TYPE} WITH_SOABI ${SOURCES} ${SWIG_GENERATED_SOURCES})
    if(${TARGET}_NO_PROXY)
    else()
        set_target_properties(${TARGET} PROPERTIES PREFIX _)
    endif()
endfunction()
