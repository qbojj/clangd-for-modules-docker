FROM archlinux

RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    pacman -Syu --noconfirm \
    base-devel clang lld python \
    git cmake ninja ccache

# build and install latest clang+clangd with c++20 modules support
COPY build-clang.sh /tmp/build-clang.sh
RUN --mount=type=tmpfs,target=/tmp/clangd-for-modules \
    --mount=type=cache,target=/root/.cache \
  /bin/bash /tmp/build-clang.sh
