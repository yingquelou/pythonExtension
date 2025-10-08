function(python_test)
    add_test(NAME ${PROJ} COMMAND py ${CMAKE_CURRENT_LIST_DIR})
    set_tests_properties(${PROJ} PROPERTIES ENVIRONMENT_MODIFICATION PYTHONPATH=path_list_prepend:$<TARGET_FILE_DIR:${PROJ}>)
endfunction()
