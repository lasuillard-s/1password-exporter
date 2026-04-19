FROM rustlang/rust:nightly-bookworm-slim@sha256:98bb52a034efd936ab6413c2e3e8f3c04b7c2b7b1b4e9a51226e20e091044733 AS builder

WORKDIR /build
COPY . .
RUN cargo build --release

FROM 1password/op:2@sha256:2aafc9794ab8d4062d0ac46c18760dc18c9c1dfe2e888ee61c3fa1ad340b5c28 AS runtime

COPY --from=builder /build/target/release/onepassword-exporter /usr/local/bin/onepassword-exporter

ENTRYPOINT ["onepassword-exporter"]
CMD ["--host", "0.0.0.0"]
