# `C++` implementation

## Requirements

* `C++` compiler with `C++23` support, e.g. `GCC 14` or `Clang 18`
* `CMake` build system, <https://cmake.org/>
* `doctest` for unit tests (if `doctest` is not installed then `CMake` will download and integrate it automatically), <https://github.com/doctest/doctest>
* `gcovr` for code coverage report with `GCC`, <https://gcovr.com>
* `llvm-cov` for code coverage report with `Clang`, <https://llvm.org/docs/CommandGuide/llvm-cov.html>

## Build

First run `cmake` to configure a build directory `<path-to-build>`

    cmake -DCMAKE_BUILD_TYPE=Debug -DWITH_COVERAGE=ON -S <path-to-source> -B <path-to-build>

and then build the project

    cmake --build <path-to-build>

## Tests and code coverage

Unit tests can be executed through `ctest`

    ctest --test-dir <path-to-build>

or directly

    <path-to-build>/lrm_test

To generate code coverage report, `CMakeLists.txt` defines a custom build target `coverage`

    cmake --build <path-to-build> --target coverage

The coverage report will be saved to `<path-to-build>/gcovr` or `<path-to-build>/llvm-cov` directory.

## Run

Program `lrm` reads the input data from a file and prints the distribution
results

    <path-to-build>/lrm <path-to-file>
