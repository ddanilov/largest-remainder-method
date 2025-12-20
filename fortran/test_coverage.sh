#!/bin/sh

fpm clean --skip
fpm test --flag "--coverage"

COVERAGE_DIR=build/gcovr
mkdir -p "$COVERAGE_DIR"
gcovr \
    --html --html-details \
    --output "$COVERAGE_DIR/index.html" \
    --exclude "build/dependencies/.*" \
    --exclude "test/.*" \
