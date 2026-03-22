# `FORTRAN` implementation

## Requirements

* `Fortran` compiler, e.g. `GFortran`
* `fpm` Fortran package manager, <https://github.com/fortran-lang/fpm>
* `gcovr` for code coverage report, <https://gcovr.com>

## Build

    fpm build

## Tests and code coverage

Unit tests can be executed by `fpm`

    fpm test

To generate code coverage report, run the following command:

    ./test_coverage.sh

The coverage report will be saved to `build/gcovr`.

## CLI application

To read input data from a file and print the distribution results run command

    fpm run -- <path-to-file>
