# SPDX-FileCopyrightText: 2024 Denis Danilov
# SPDX-License-Identifier: GPL-3.0-only

cmake_minimum_required(VERSION 3.16)

project(largest-remainder LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

enable_testing(TRUE)
find_package(doctest REQUIRED)
add_executable(lrm_test test.cpp)
target_link_libraries(lrm_test PRIVATE doctest::doctest)
add_test(NAME lrm_test COMMAND lrm_test)
