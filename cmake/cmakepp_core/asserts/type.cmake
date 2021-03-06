include_guard()
include(cmakepp_core/types/implicitly_convertible)
include(cmakepp_core/types/type_of)
include(cmakepp_core/utilities/assert)
include(cmakepp_core/utilities/enable_if_debug)

#[[[ Tests that the provided object can be implicitly cast to the provided type.
#
# If CMakePP is run in debug mode, this function will throw an error if the
# provided object is not implicitly convertible to the provided type. If CMakePP
# is not being run in debug mode, then this function is a no-op.
#
# :param _at_type: The type that the type of the object must be implicitly
#                  convertible to.
# :type _at_type: type
# :param _at_obj: The object whose type must be implicitly convertible to
#                 ``_at_type``.
# :type _at_obj: str
# :var CMAKEPP_CORE_DEBUG_MODE: Used to determine if CMakePP is being run in
#                               debug mode
# :vartype CMAKEPP_CORE_DEBUG_MODE: bool
#
# Error Checking
# ==============
#
# In addition to asserting that the provided object's type is implicitly
# convertible to the provided type. This function will also ensure that the
# caller has only provided two arguments and that ``_at_type`` is actually a
# type. These additional error checks are also only done when CMakePP is run in
# debug mode.
#]]
function(cpp_assert_type _at_type _at_obj)
    cpp_enable_if_debug()
    # Check the signature of this call
    cpp_type_of(_at_type_type "${_at_type}")
    cpp_implicitly_convertible(_at_convertible "${_at_type_type}" "type")
    cpp_assert(
        "${_at_convertible}" "${_at_type_type} is convertible to type"
    )

    if(NOT "${ARGC}" EQUAL 2)
        message(
            FATAL_ERROR
            "Function takes 2 argument(s), but ${ARGC} was/were provided."
        )
    endif()

    cpp_type_of(_at_obj_type "${_at_obj}")
    cpp_implicitly_convertible(_at_convertible "${_at_obj_type}" "${_at_type}")
    cpp_assert(
        "${_at_convertible}" "${_at_obj_type} is convertible to ${_at_type}"
    )
endfunction()
