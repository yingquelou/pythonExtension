set(Python_USE_STATIC_LIBS TRUE)
find_package(Python COMPONENTS Development Interpreter)

if(Python_FOUND)
    # include_directories(${Python_INCLUDE_DIRS})
    # 当前目录下,除py目标外,其余目标都是python扩展
    # py目标可通过gdb或MSVC从c/c++代码层面调试python扩展
    # 通过设置MODULE_NAME,指定需要调试python扩展
    # 被调试python扩展将以静态库的方式构建
    # 当前目录下的目标都应遵循上述约定

    # MODULE_NAME : Configure the name of the module to be debugged
    # set(MODULE_NAME utils)
    include(python_test)
    router_directories()
endif()