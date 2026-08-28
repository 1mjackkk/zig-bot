FROM alpine:3.19 AS builder

RUN apk add --no-cache curl xz tar build-base

# Exact valid official 0.11.0 release download
RUN curl -sSL https://ziglang.org/download/0.11.0/zig-linux-x86_64-0.11.0.tar.xz -o zig.tar.xz && \
    tar -xf zig.tar.xz -C /usr/local && \
    rm zig.tar.xz

ENV PATH="/usr/local/zig-linux-x86_64-0.11.0:${PATH}"

WORKDIR /app
COPY . .

# Run build with fallback compatibility flags
RUN zig build -Doptimize=ReleaseFast

FROM alpine:3.19
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app
COPY --from=builder /app/zig-out/bin/telegram_battalion_bot /app/telegram_battalion_bot

CMD ["/app/telegram_battalion_bot"]
