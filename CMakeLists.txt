cmake_minimum_required(VERSION 3.10)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake_module ${CMAKE_MODULE_PATH})
cmake_path(GET CMAKE_CURRENT_LIST_DIR FILENAME PROJ)

project(${PROJ})
include(router)
enable_testing()
router_directories()
