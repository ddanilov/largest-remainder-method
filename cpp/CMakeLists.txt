# SPDX-FileCopyrightText: 2024-2025 Denis Danilov
# SPDX-License-Identifier: GPL-3.0-only

cmake_minimum_required(VERSION 3.28)

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

    if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
      find_program(LLVM_PROFDATA llvm-profdata REQUIRED)
      find_program(LLVM_COV llvm-cov REQUIRED)
      add_compile_options(-fprofile-instr-generate -fcoverage-mapping)
      add_link_options(-fprofile-instr-generate -fcoverage-mapping)
      set(COVERAGE_DIR "llvm-cov")
      message(STATUS "coverage report: ${PROJECT_BINARY_DIR}/${COVERAGE_DIR}")
      file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/${COVERAGE_DIR})
      add_custom_target(coverage
        COMMAND ${CMAKE_COMMAND} -E env "LLVM_PROFILE_FILE=lrm_test.profraw" $<TARGET_FILE:lrm_test>
        COMMAND ${LLVM_PROFDATA} merge -o lrm_test.profdata lrm_test.profraw
        COMMAND ${LLVM_COV} show
        -instr-profile=lrm_test.profdata
        --ignore-filename-regex=".*test.cpp"
        --format html
        -output-dir=${COVERAGE_DIR}
        lrm_test
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR})
    endif()
endif()

include(FetchContent)
FetchContent_Declare(
    doctest
    GIT_REPOSITORY https://github.com/doctest/doctest.git
    GIT_TAG        v2.4.11
    EXCLUDE_FROM_ALL
    FIND_PACKAGE_ARGS
)
FetchContent_MakeAvailable(doctest)

enable_testing(TRUE)
add_executable(lrm_test test.cpp)
target_link_libraries(lrm_test PRIVATE doctest::doctest)
add_test(NAME lrm_test COMMAND lrm_test)

add_executable(lrm lrm.cpp)
