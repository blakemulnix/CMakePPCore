include_guard()
include(cmakepp_core/utilities/sanitize_string)

#[[[ Appends a value to a global list.
#
# When we are manipulating a global state, which is actually a list, we often
# want to append to it and not "set" it (set in this context referring to
# overwriting the value with a new value). This function will append to the
# specified global variable the provided value. If the variable does not exist,
# the variable will be created and initialized to the provided value.
#
# :param _ag_key: The name of the global variable to append to. ``_ag_key`` is
#                 case-insensitive.
# :type _ag_key: desc
# :param _ag_value: The value to append to ``_ag_key`'s current value.
# :type _ag_value: str
#
# Error Checking
# ==============
#
# ``cpp_append_global`` will assert that it is called with only two arguments.
#]]
function(cpp_append_global _ag_key _ag_value)
    if(NOT ${ARGC} EQUAL 2)
        message(FATAL_ERROR "cpp_append_global accepts exactly 2 arguments.")
    endif()

    cpp_sanitize_string(_ag_key "${_ag_key}")
    set_property(
        GLOBAL APPEND PROPERTY "__cpp_${_ag_key}_global__" "${_ag_value}"
    )
endfunction()

#[[[ Sets a global variable to the provided value.
#
# This function will set a global variable to the value provided. If the global
# variable already exists it will overwrite its current value.
#
# :param _sg_key: The name of the global variable to set. ``_ag_key`` is
#                 case-insensitive.
# :type _sg_key: desc
# :param _sg_value: The value to set ``_sg_key`` to.
# :type _sg_value: str
#
# Error Checking
# ==============
#
# ``cpp_set_global`` will assert that it is called with only two arguments.
#]]
function(cpp_set_global _sg_key _sg_value)
    if(NOT ${ARGC} EQUAL 2)
        message(FATAL_ERROR "cpp_set_global accepts exactly 2 arguments.")
    endif()

    cpp_sanitize_string(_sg_key "${_sg_key}")
    set_property(GLOBAL PROPERTY "__cpp_${_sg_key}_global__" "${_sg_value}")
endfunction()

#[[[ Retrieves the value of the requested global variable.
#
# This function will get the value of the specified global variable. If the
# variable does not exist the empty string will be returned. It is thus not
# possible to discern between an uninitialized global variable and one set to
# the empty string. In practice this is not a problem because global variables
# are not typically set to the empty string.
#
# :param _gg_result: Identifier for the variable which after this call will hold
#                    the value stored in global variable ``_gg_key``.
# :type _gg_value: desc
# :param _gg_key: The name of the global variable whose value has been
#                 requested. ``_gg_key`` is case-insensitive.
# :type _gg_key: desc
# :returns: ``_gg_result`` will be set to the value stored in global variable
#           ``_gg_key``. If ``_gg_key`` has not been set ``_gg_result`` will be
#           set to the empty string.
# :rtype: str
#
# Error Checking
# ==============
#
# ``cpp_get_global`` will assert that it is called with only two arguments.
#]]
function(cpp_get_global _gg_result _gg_key)
    if(NOT ${ARGC} EQUAL 2)
        message(FATAL_ERROR "cpp_get_global accepts exactly 2 arguments.")
    endif()

    cpp_sanitize_string(_gg_key "${_gg_key}")
    get_property("${_gg_result}" GLOBAL PROPERTY "__cpp_${_gg_key}_global__")
    set("${_gg_result}" "${${_gg_result}}" PARENT_SCOPE)
endfunction()
