# `C++` implementation

## Requirements

* `C++` compiler with `C++23` support, e.g. `GCC 14` or `Clang 18`
* `CMake` build system, <https://cmake.org/>
* `doctest` for unit tests, <https://github.com/doctest/doctest>

## Build

First run `cmake` to configure a build directory `<path-to-build>`

    cmake -DCMAKE_BUILD_TYPE=Debug -S <path-to-source> -B <path-to-build>

and then build the project

    cmake --build <path-to-build>

## Tests

Unit tests can be executed through `ctest`

    ctest --test-dir <path-to-build>

or directly

    <path-to-build>/lrm_test
