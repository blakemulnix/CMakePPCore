# Get CMakeTest and add it to our module path
include(FetchContent)
FetchContent_Declare(
    cmake_test
    GIT_REPOSITORY https://github.com/CMakePP/CMakeTest
)
set(build_testing_old "${BUILD_TESTING}")
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(cmake_test)
set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)

# Define a function to make it easier to add tests to CTest
function(add_cmake_unit_tests prefix)
    string(REGEX REPLACE ";" "\\\;" test_path "${CMAKE_MODULE_PATH}")
    foreach(testi ${ARGN})
        set(full_path ${CMAKE_CURRENT_LIST_DIR}/${testi}.cmake)
        add_test(
                NAME "${prefix}:${testi}"
                COMMAND ${CMAKE_COMMAND}
                -DCMAKE_MODULE_PATH=${test_path} -P ${full_path}
        )
    endforeach()
endfunction()

add_subdirectory(algorithm)
add_subdirectory(asserts)
add_subdirectory(class)
add_subdirectory(examples)
add_subdirectory(exceptions)
add_subdirectory(map)
add_subdirectory(object)
add_subdirectory(serialization)
add_subdirectory(types)
add_subdirectory(utilities)

# Stress tests can take a long time to run
#add_subdirectory(stress_tests)
