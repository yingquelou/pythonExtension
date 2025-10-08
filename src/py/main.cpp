#define PY_SSIZE_T_CLEAN
#include <Python.h>
#ifdef PyInit_MODULE
PyMODINIT_FUNC PyInit_MODULE();
#endif
#define Check(exp)                     \
    do                                 \
    {                                  \
        if (PyStatus_Exception((exp))) \
        {                              \
            goto exception;            \
        }                              \
    } while (0)
int main(int argc, char *argv[])
{
    PyStatus status;
    PyConfig config;
    PyConfig_InitPythonConfig(&config);

    // 根据CMake 变量MODULE_NAME以configure_file实现调试指定python模块
#if defined PyInit_MODULE && defined __MODULE_NAME__
    PyImport_AppendInittab(__MODULE_NAME__, PyInit_MODULE);
#endif

    Check(status = PyConfig_SetBytesArgv(&config, argc, argv));
    Check(status = Py_InitializeFromConfig(&config));
    PyConfig_Clear(&config);

    return Py_RunMain();

exception:
    PyConfig_Clear(&config);
    Py_ExitStatusException(status);
}