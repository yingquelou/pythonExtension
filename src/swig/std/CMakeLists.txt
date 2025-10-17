cmake_path(GET CMAKE_CURRENT_LIST_DIR STEM PROJ)
swig_python_library(${PROJ} SOURCE std.i)
swig_test()