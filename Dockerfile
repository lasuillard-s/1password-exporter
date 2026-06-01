FROM rustlang/rust:nightly-slim-trixie-2026-06-01 AS builder

WORKDIR /build
COPY . .
RUN cargo build --release

FROM 1password/op:2.34.0 AS runtime

COPY --from=builder /build/target/release/onepassword-exporter /usr/local/bin/onepassword-exporter

ENTRYPOINT ["onepassword-exporter"]
CMD ["--host", "0.0.0.0"]
