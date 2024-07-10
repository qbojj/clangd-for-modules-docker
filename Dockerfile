FROM archlinux:latest

RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    pacman -Syu --noconfirm base-devel clang lld python cmake ccache

# build and install latest clang+clangd with c++20 modules support
COPY clangd-for-modules/ /tmp/clangd-for-modules
WORKDIR /tmp/clangd-for-modules
RUN --mount=type=cache,target=/root/.cache <<-EOF
set -xe

cmake -Sllvm -Bbuild \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_USE_LINKER=lld \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_C_COMPILER=clang 

cmake --build build
cmake --install build

cd /
rm -rf /tmp/clangd-for-modules

EOF

WORKDIR /root
