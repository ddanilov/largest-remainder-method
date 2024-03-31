# SPDX-FileCopyrightText: 2024 Denis Danilov
# SPDX-License-Identifier: GPL-3.0-only

cmake_minimum_required(VERSION 3.16)

project(largest-remainder LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

option(WITH_COVERAGE "Enable code coverage report." OFF)
if(WITH_COVERAGE)
    if(NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
        message(SEND_ERROR "not a Debug build")
    endif()

    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        find_program(GCOVR gcovr REQUIRED)
        add_compile_options(--coverage)
        add_link_options(--coverage)
        set(COVERAGE_DIR "gcovr")
        message(STATUS "coverage report: ${PROJECT_BINARY_DIR}/${COVERAGE_DIR}")
        file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/${COVERAGE_DIR})
        add_custom_target(coverage
            COMMAND $<TARGET_FILE:lrm_test>
            COMMAND gcovr
            --html --html-details
            --exclude ".*test.cpp"
            --output ${COVERAGE_DIR}/index.html
            --root ${PROJECT_SOURCE_DIR}
            --object-directory ${PROJECT_BINARY_DIR}
            WORKING_DIRECTORY ${PROJECT_BINARY_DIR})
    endif()
endif()

enable_testing(TRUE)
find_package(doctest REQUIRED)
add_executable(lrm_test test.cpp)
target_link_libraries(lrm_test PRIVATE doctest::doctest)
add_test(NAME lrm_test COMMAND lrm_test)
