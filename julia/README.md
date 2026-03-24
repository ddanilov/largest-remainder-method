# `Julia` implementation

## Requirements

* `Julia` programming language, <https://julialang.org>
* `LocalCoverage.jl` package, <https://github.com/JuliaCI/LocalCoverage.jl>
* `genhtml` from `lcov` for HTML coverage report, <https://github.com/linux-test-project/lcov>

## Tests and code coverage

Unit tests can be executed with command

    julia --project test/runtests.jl

or

    julia --project --eval 'using Pkg; Pkg.test()'

To generate code coverage report, install `LocalCoverage.jl` with
`using Pkg; Pkg.add("LocalCoverage")` or `]add LocalCoverage` from the Julia REPL and run

    julia --project --eval 'using LocalCoverage; report_coverage_and_exit(target_coverage=90)'

or

    julia --project --eval 'using LocalCoverage; html_coverage(open=true)'

## CLI application

To read input data from a file and print the distribution results run command

    julia --project app/lrm_cli.jl <path-to-file>
