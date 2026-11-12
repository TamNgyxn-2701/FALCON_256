#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

mkdir -p build_v7

# Compile
vcs -debug +v2k -sverilog \
    -f listfile_v7.f \
    -l build_v7/compile_v7.log \
    -o build_v7/simv


./build_v7/simv \
    -l build_v7/run_v7.log
