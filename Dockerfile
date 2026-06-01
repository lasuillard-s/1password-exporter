FROM rustlang/rust:1.96.0-slim-trixie@sha256:7be7e62dbd0954a32c340afe3df951d75dde2859549b2b72fdd4a8c842b37534 AS builder

WORKDIR /build
COPY . .
RUN cargo build --release

FROM 1password/op:2@sha256:2aafc9794ab8d4062d0ac46c18760dc18c9c1dfe2e888ee61c3fa1ad340b5c28 AS runtime

COPY --from=builder /build/target/release/onepassword-exporter /usr/local/bin/onepassword-exporter

ENTRYPOINT ["onepassword-exporter"]
CMD ["--host", "0.0.0.0"]
