FROM rustlang/rust:nightly-bookworm-slim@sha256:4c258f6131cacc085a6edcd0148eb37cbac77b40c770241ea724ec3660aff032 AS builder

WORKDIR /build
COPY . .
RUN cargo build --release

FROM 1password/op:2@sha256:2aafc9794ab8d4062d0ac46c18760dc18c9c1dfe2e888ee61c3fa1ad340b5c28 AS runtime

COPY --from=builder /build/target/release/onepassword-exporter /usr/local/bin/onepassword-exporter

ENTRYPOINT ["onepassword-exporter"]
CMD ["--host", "0.0.0.0"]
