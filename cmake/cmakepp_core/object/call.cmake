include_guard()
include(cmakepp_core/object/object)
include(cmakepp_core/types/type_of)
include(cmakepp_core/utilities/call_fxn)
include(cmakepp_core/utilities/print_fxn_sig)
include(cmakepp_core/utilities/sanitize_string)

#[[[ Determines the correct member function to call for the input.
#
# This function is factored out of ``_cpp_object_call`` to avoid contaminating
# the caller's namespace with temporary variables needed to lookup the symbol of
# the member function we are calling.
#
# :param _ocg_this: The Object instance whose member function is being called.
# :type _ocg_this: obj
# :param _ocg_result: Identifier to hold the symbol of the function to call.
# :type _ocg_result: desc
# :param _ocg_method: The name of the method to call. The actual name is
#                     case-insensitive.
# :type _ocg_method: desc
# :param *args: The arguments which are being forwarded to the member function.
# :returns: ``_ocg_result`` will be set to the symbol (mangled name) of the
#           member function to call.
# :rtype: fxn
#
# .. note::
#
#    This function is considered an implementation detail of
#    ``_cpp_object_call`` and does not perform any type checking.
#
# Error Checking
# ==============
#
# This function will raise an error if the Object instance does not contain a
# member function capable of being called with the provided signature.
#]]
function(_cpp_object_call_guts _ocg_this _ocg_result _ocg_method)

    # Make the signature (tuple with name of fxn and arg types) we want
    cpp_sanitize_string(_ocg_nice_method "${_ocg_method}")
    set(_ocg_sig "${_ocg_nice_method}")
    foreach(_ocg_arg_i "${_ocg_this}" ${ARGN})
        cpp_type_of(_ocg_type_i "${_ocg_arg_i}")
        cpp_sanitize_string(_ocg_nice_type_i "${_ocg_type_i}")
        list(APPEND _ocg_sig "${_ocg_nice_type_i}")
    endforeach()

    # Get the symbol for the member function honoring that signature
    _cpp_object_get_symbol("${_ocg_this}" _ocg_symbol _ocg_sig)
    if(NOT _ocg_symbol)
        cpp_print_fxn_sig(_oc_str_sig ${_ocg_sig})
        message(FATAL_ERROR "No suitable overload of ${_oc_str_sig}")
    endif()

    # Return the symbol
    set("${_ocg_result}" "${_ocg_symbol}" PARENT_SCOPE)
endfunction()

#[[[ Calls the specified member function.
#
# This is the "public" API (users of CMakePP should rarely need to go through
# the Object class directly) for calling an Object instance's member function.
# This function encapsulates the process of determining the correct overload to
# call and actually invoking it.
#
# :param _oc_this: The Object instance whose member function is being called.
# :type _oc_this: obj
# :param _oc_method: The name of the member function to call.
# :type _oc_method: desc
# :param *args: The arguments to forward to the member function (the required
#               first argument of the ``this`` pointer is forwarded
#               automatically and should not be provided in this list)
# :returns: This function will return whatever the member function returns
#           using the mechanism of that function. If the member function does
#           not return this function will not return.
# :rtype: str
#
# .. note::
#
#    This command is a macro to avoid needing to forward the results of the
#    subcall.
#
# Error Checking
# ==============
#
# If CMakePP is run in debug mode (and only if CMakePP is run in debug mode)
# this function will ensure that it was called with the correct number and types
# of arguments. If it is not an error will be raised.
#
# :var CMAKEPP_CORE_DEBUG_MODE: Used to determine if CMakePP is being run in
#                              debug mode or not.
# :vartype CMAKEPP_CORE_DEBUG_MODE: bool
#
# Additionally, this function will raise an error if the Object instance does
# not contain a suitable overload for the provided arguments.
#]]
macro(_cpp_object_call _oc_this _oc_method)
    cpp_assert_signature("${ARGV}" obj desc args)

    _cpp_object_call_guts("${_oc_this}" __oc__symbol "${_oc_method}" ${ARGN})
    cpp_call_fxn("${__oc__symbol}" "${_oc_this}" ${ARGN})
endmacro()
