FROM rustlang/rust:nightly-bookworm-slim@sha256:4982e9a31e5b79c8f054f9e8fbb54b7d8f10206d9fc9b2ca056602ae8f8d63f6 AS builder

WORKDIR /build
COPY . .
RUN cargo build --release

FROM 1password/op:2@sha256:ef2454e1af295479ced26ca4516694310c4074a54f5071db9bb8e793845ce690 AS runtime

COPY --from=builder /build/target/release/onepassword-exporter /usr/local/bin/onepassword-exporter

ENTRYPOINT ["onepassword-exporter"]
CMD ["--host", "0.0.0.0"]
