FROM archlinux:latest

# build and install latest clang+clangd with c++20 modules support
COPY clangd-for-modules/ /tmp/clangd-for-modules
RUN <<-EOF
set -xe

pacman -Syu --noconfirm base-devel clang lld python cmake

cd /tmp/clangd-for-modules

cmake -Sllvm -Bbuild \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_PARALLEL_LINK_JOBS=1 \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" \
  -DLLVM_USE_LINKER=lld \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_C_COMPILER=clang 

cmake --build build --parallel $(nproc)
cmake --install build --strip

rm -rf ./build

pacman -Rcns --noconfirm clang

EOF
