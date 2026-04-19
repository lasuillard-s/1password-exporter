FROM rustlang/rust:nightly-bookworm-slim@sha256:9aba8b2c61f670860215f020f993bcc4f8a5138f31865fa697a4397769490c90 AS builder

WORKDIR /build
COPY . .
RUN cargo build --release

FROM 1password/op:2@sha256:ef2454e1af295479ced26ca4516694310c4074a54f5071db9bb8e793845ce690 AS runtime

COPY --from=builder /build/target/release/onepassword-exporter /usr/local/bin/onepassword-exporter

ENTRYPOINT ["onepassword-exporter"]
CMD ["--host", "0.0.0.0"]
