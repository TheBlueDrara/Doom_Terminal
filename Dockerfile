FROM ubuntu:24.10 AS setup
RUN apt-get update && \
    apt-get install -y curl build-essential && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN curl -LO https://ziglang.org/download/0.14.0/zig-linux-x86_64-0.14.0.tar.xz && \
    tar -xf zig-linux-x86_64-0.14.0.tar.xz

ENV PATH="/app/zig-linux-x86_64-0.14.0/:${PATH}"
RUN git clone https://github.com/cryptocode/terminal-doom.git
WORKDIR /app/terminal-doom
RUN zig build -Doptimize=ReleaseFast


FROM setup
RUN apt-get update && \
    apt-get install -y libasound2t64 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /doom
COPY --from=setup /app/terminal-doom/ /doom
CMD ["./zig-out/bin/terminal-doom"]

