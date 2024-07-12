FROM archlinux:latest

# build and install latest clang+clangd with c++20 modules support
RUN --mount=type=cache,target=/var/cache/pacman/pkg <<-EOF
set -xe

pacman -Syu --noconfirm base-devel clang lld python cmake git

cd /tmp
git clone https://github.com/ChuanqiXu9/clangd-for-modules.git
cd clangd-for-modules

#REPLACE
git checkout 21c5f3ffa19dd3d02bd5bdb67bacf37dfade1764

cmake -Sllvm -Bbuild \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_PARALLEL_LINK_JOBS=1 \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" \
  -DLLVM_USE_LINKER=lld \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_C_COMPILER=clang 

cmake --build build --parallel $(nproc)
cmake --install build --strip

cd /
rm -rf /tmp/clangd-for-modules

pacman -Rcns --noconfirm clang

EOF
