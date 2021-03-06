include_guard()

#[[[ Asserts that provided value is true.
#
# The ``cpp_assert`` function is code factorization for the very common scenario
# where we want to crash the program if a condition is not met.
#
# :param _ca_cond: The condition which should be true. This can be anything that
#                  can be passed to CMake's ``if`` statement; however, if the
#                  condition is not a single argument it must be provided as a
#                  list, *e.g.*, ``x STREQUAL x`` becomes ``x;STREQUAL;x``.
# :type _ca_cond: bool or str or list(str)
# :param _ca_desc: Human-readable description of the assertion.
# :type _ca_desc: str
#
# Example Usage:
# ==============
#
# This first example shows how to use ``cpp_assert`` to ensure that an object is
# a particular type (in this case an integer). It should be noted that this same
# functionality is provided by the ``cpp_assert_int`` function and does not need
# to be reimplemented.
#
# .. code-block:: cmake
#
#    include(cmakepp_core/utilities/assert)
#    include(cmakepp_core/types/integer)
#    cpp_is_int(is_int 3)
#    cpp_assert("${_is_int}" "3 is an integer")
#
# This second example shows how to pass an actual condition as opposed to a
# result:
#
# .. code-block:: cmake
#
#    include(cmakepp_core/utilities/assert)
#    set(x 4)
#    cpp_assert("${x};GREATER;3" "x is > 3")
#]]
function(cpp_assert _ca_cond _ca_desc)
    if(NOT ${_ca_cond})
        message(FATAL_ERROR "Assertion: ${_ca_desc} failed.")
    endif()
endfunction()
