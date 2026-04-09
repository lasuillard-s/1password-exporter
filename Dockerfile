FROM rustlang/rust:nightly-bookworm-slim@sha256:221be5ed522d85fb3eaabd5c2a0c7fffd0a643ad6d615ca76f6994c8f1b3770d AS builder

WORKDIR /build
COPY . .
RUN cargo build --release

FROM 1password/op:2@sha256:ef2454e1af295479ced26ca4516694310c4074a54f5071db9bb8e793845ce690 AS runtime

COPY --from=builder /build/target/release/onepassword-exporter /usr/local/bin/onepassword-exporter

ENTRYPOINT ["onepassword-exporter"]
CMD ["--host", "0.0.0.0"]
