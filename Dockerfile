FROM alpine:3.19 AS builder

RUN apk add --no-cache curl xz tar build-base

# Download Exact Patch Version Zig 0.11.3
RUN curl -sSL https://ziglang.org/download/0.11.3/zig-linux-x86_64-0.11.3.tar.xz | tar -xJ -C /usr/local
ENV PATH="/usr/local/zig-linux-x86_64-0.11.3:${PATH}"

WORKDIR /app
COPY . .

RUN zig build -Doptimize=ReleaseFast

FROM alpine:3.19
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app
COPY --from=builder /app/zig-out/bin/telegram_battalion_bot /app/telegram_battalion_bot

CMD ["/app/telegram_battalion_bot"]
