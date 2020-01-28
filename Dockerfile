FROM ubuntu:rolling

WORKDIR /root
USER root
RUN apt-get update --no-install-recommends
RUN apt-get install --no-install-recommends -y \
        clang lld qemu-system-x86 \
        ca-certificates curl file
RUN rm -rf /var/lib/apt/lists/*
RUN curl https://github.com/qemu/qemu/raw/stable-4.0/pc-bios/pvh.bin > /usr/share/qemu/pvh.bin 
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain=nightly --profile=minimal -y
ENV PATH=/root/.cargo/bin:$PATH
RUN rustup toolchain add nightly
RUN rustup default nightly
RUN rustup component add rustfmt --toolchain nightly
RUN rustup component add rust-src --toolchain nightly
RUN rustup component add llvm-tools-preview --toolchain nightly
RUN rustup target add x86_64-unknown-linux-musl --toolchain nightly
RUN cargo install cargo-xbuild

