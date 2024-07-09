#!/bin/bash

set -e

mkdir -p /tmp/clangd-for-modules
cd /tmp/clangd-for-modules

git clone --depth=1 https://github.com/ChuanqiXu9/clangd-for-modules .

cmake -Sllvm/ -Bbuild \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_USE_LINKER=lld \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_C_COMPILER=clang

cmake --build build
cmake --install build
