FROM rustlang/rust:nightly-bookworm-slim@sha256:22dd7c7a5bb7677c6f83d72948026e0b59988a0fbe37b65fc5a705214afe4c78 AS builder

WORKDIR /build
COPY . .
RUN cargo build --release

FROM 1password/op:2@sha256:ef2454e1af295479ced26ca4516694310c4074a54f5071db9bb8e793845ce690 AS runtime

COPY --from=builder /build/target/release/onepassword-exporter /usr/local/bin/onepassword-exporter

ENTRYPOINT ["onepassword-exporter"]
CMD ["--host", "0.0.0.0"]
