FROM rustlang/rust:nightly-bookworm-slim@sha256:4951895f45eea19cbebd2af132cdb7f8362a0b7b591db08f0e00a777df943225 AS builder

WORKDIR /build
COPY . .
RUN cargo build --release

FROM 1password/op:2@sha256:ef2454e1af295479ced26ca4516694310c4074a54f5071db9bb8e793845ce690 AS runtime

COPY --from=builder /build/target/release/onepassword-exporter /usr/local/bin/onepassword-exporter

ENTRYPOINT ["onepassword-exporter"]
CMD ["--host", "0.0.0.0"]
