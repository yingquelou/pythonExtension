#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <windows.h>
// 使用第三方工具前,了解如何使用C/C++创建python扩展
static PyObject *mod_create(PyObject *spec, PyModuleDef *def)
{
    PyObject *mod = PyModule_New(def->m_name);

    return mod;
}
static int mod_exec(PyObject *mod)
{
    return 0;
}
static PyModuleDef_Slot slots[]{
    {Py_mod_create, (void *)mod_create},
    {Py_mod_exec, (void *)mod_exec},
    {0}};
static PyMethodDef methods[]{
    {"CLSIDFromProgID", [](PyObject *self, PyObject *args) -> PyObject *
     {
         PyObject *clsid_py = nullptr;
         PyArg_ParseTuple(args, "O", &clsid_py);
         if (!PyUnicode_Check(clsid_py))
         {
             PyErr_SetString(PyExc_TypeError, "Argument must be a string");
             return nullptr;
         }
         Py_ssize_t len = 0;
         wchar_t *clsid = PyUnicode_AsWideCharString(clsid_py, &len);
         CLSID clsid_out;
         HRESULT hr;
         if (FAILED(hr = CLSIDFromProgID(clsid, &clsid_out)))
         {
             PyErr_SetString(PyExc_RuntimeError, "Failed to get CLSID from ProgID");
             return nullptr;
         }
         if (FAILED(StringFromCLSID(clsid_out, &clsid)))
         {
             PyErr_SetString(PyExc_RuntimeError, "Failed to get string from CLSID");
             return nullptr;
         }
         return PyUnicode_FromWideChar(clsid, -1);
     },
     METH_VARARGS},
    {"ProgIDFromCLSID", [](PyObject *self, PyObject *args) -> PyObject *
     {
         PyObject *clsid_py = nullptr;
         PyArg_ParseTuple(args, "O", &clsid_py);
         if (!PyUnicode_Check(clsid_py))
         {
             PyErr_SetString(PyExc_TypeError, "Argument must be a string");
             return nullptr;
         }
         Py_ssize_t len = 0;
         wchar_t *clsid = PyUnicode_AsWideCharString(clsid_py, &len);
         CLSID clsid_out;
         HRESULT hr;
         if (FAILED(hr = CLSIDFromString(clsid, &clsid_out)))
         {
             PyErr_SetString(PyExc_RuntimeError, "Failed to get CLSID from ProgID");
             return nullptr;
         }
         if (FAILED(StringFromCLSID(clsid_out, &clsid)))
         {
             PyErr_SetString(PyExc_RuntimeError, "Failed to get string from CLSID");
             return nullptr;
         }
         return PyUnicode_FromWideChar(clsid, -1);
     },
     METH_VARARGS},
    {"FormatMessageAsUnicode", [](PyObject *self, PyObject *args) -> PyObject *
     {
         PyObject *hr_py = nullptr;
         PyArg_ParseTuple(args, "O", &hr_py);
         if (!PyLong_Check(hr_py))
         {
             PyErr_SetString(PyExc_TypeError, "Argument must be a integer");
             return nullptr;
         }
         HRESULT hr = PyLong_AsLong(hr_py);
         char *msg = nullptr;
         FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
                       nullptr, hr, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPSTR)&msg, 0, nullptr);
         //   获取的字符串msg传递给PyUnicode_FromString时码点不对，所以需要转换为Unicode
         PyObject *py_msg = PyUnicode_Decode(msg, strlen(msg), "gb2312", nullptr);
         LocalFree(msg);
         return py_msg;
     },
     METH_VARARGS},
    {"GetLastError", [](PyObject *self, PyObject *args) -> PyObject *
     {
         return PyLong_FromLong(GetLastError());
     },
     METH_VARARGS},
    {"SetLastError", [](PyObject *self, PyObject *args) -> PyObject *
     {
         PyObject *err_py = nullptr;
         PyArg_ParseTuple(args, "O", &err_py);
         if (!PyLong_Check(err_py))
         {
             PyErr_SetString(PyExc_TypeError, "Argument must be a integer");
             return nullptr;
         }
         SetLastError(PyLong_AsLong(err_py));
         Py_RETURN_NONE;
     },
     METH_VARARGS},
    {nullptr}};
static PyModuleDef def{
    .m_base = PyModuleDef_HEAD_INIT,
    .m_name = __MODULE_NAME__,
    .m_doc = __MODULE_NAME__ " module",
    .m_size = 0,
    .m_methods = methods,
    .m_slots = slots};
PyMODINIT_FUNC PyInit_MODULE()
{
    return PyModuleDef_Init(&def);
}