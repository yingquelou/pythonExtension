# 查找相应目录下所有包含CMakeLists.txt文件的子目录,并add_subdirectory
function(router_directories)
    file(GLOB WALK *)
    foreach(ITEM IN LISTS WALK)
        cmake_path(APPEND CMAKE_FILE ${ITEM} CMakeLists.txt)
        if(EXISTS ${CMAKE_FILE})
            add_subdirectory(${ITEM})
        endif()
    endforeach()
endfunction()
function(router_files)
    cmake_parse_arguments(${CMAKE_CURRENT_FUNCTION} "" "INCLUDES;EXCLUDES" "" ${ARGN})
    file(GLOB WALK LIST_DIRECTORIES FALSE RELATIVE ${CMAKE_CURRENT_LIST_DIR} "${${CMAKE_CURRENT_FUNCTION}_INCLUDES}")

    
    if(${CMAKE_CURRENT_FUNCTION}_EXCLUDES)
        list(REMOVE_ITEM WALK "${${CMAKE_CURRENT_FUNCTION}_EXCLUDES}")
    endif()
    
    foreach(ITEM IN LISTS WALK)
        cmake_path(GET ITEM STEM LAST_ONLY PROJ)
        add_executable(${PROJ} ${ITEM})
    endforeach()
endfunction()