# `FORTRAN` implementation

## Requirements

* Fortran compiler, e.g. `GFortran`
* Fortran Package Manager `fpm`, <https://github.com/fortran-lang/fpm>
* `gcovr` for code coverage report, <https://gcovr.com>

## Build

    fpm build

## Tests

Unit tests can be executed through `fpm`

    fpm test

To generate code coverage report, run the following command:

    ./test_coverage.sh

The coverage report will be saved to `build/gcovr`.
