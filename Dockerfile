FROM rustlang/rust:nightly-bookworm-slim@sha256:e4e91f70251b9ebb9e140913e23d9bed16b5c0c475ef96e0b84c6d7d709d11be AS builder

WORKDIR /build
COPY . .
RUN cargo build --release

FROM 1password/op:2@sha256:2aafc9794ab8d4062d0ac46c18760dc18c9c1dfe2e888ee61c3fa1ad340b5c28 AS runtime

COPY --from=builder /build/target/release/onepassword-exporter /usr/local/bin/onepassword-exporter

ENTRYPOINT ["onepassword-exporter"]
CMD ["--host", "0.0.0.0"]
