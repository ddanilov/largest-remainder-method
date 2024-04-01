# `Clojure` implementation

## Requirements

* `Clojure` programming language, <https://clojure.org/>
* `Java` runtime, <https://openjdk.org/>

## Tests and code coverage

Unit tests can be executed with command

    clojure -X:test/kaocha

It will also generate code coverage report in `target/coverage` directory.

## Run

To read input data from a file and print the distribution results run command

    clojure -M:run/main <path-to-file>
