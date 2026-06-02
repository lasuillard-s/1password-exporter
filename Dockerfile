FROM rustlang/rust:nightly-trixie-slim-2026-06-01@sha256:f6e6b7f6a48b32045e389730a75ace6a949bcedd4098c8acbdc26b9fd8f614b0 AS builder

WORKDIR /build
COPY . .
RUN cargo build --release

FROM debian:trixie-slim@sha256:b6e2a152f22a40ff69d92cb397223c906017e1391a73c952b588e51af8883bf8 AS runtime

RUN apt update --yes && apt install --yes \
    ca-certificates \
    curl \
    gnupg \
    && rm --recursive --force /var/lib/apt/lists

# Register 1Password CLI repository
RUN curl --silent --show-error https://downloads.1password.com/linux/keys/1password.asc \
    | gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" \
    | tee /etc/apt/sources.list.d/1password.list \
    && mkdir --parents /etc/debsig/policies/AC2D62742012EA22/ \
    && curl --silent --show-error https://downloads.1password.com/linux/debian/debsig/1password.pol \
    | tee /etc/debsig/policies/AC2D62742012EA22/1password.pol \
    && mkdir --parents /usr/share/debsig/keyrings/AC2D62742012EA22 \
    && curl --silent --show-error https://downloads.1password.com/linux/keys/1password.asc \
    | gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

# Install 1Password CLI
RUN apt update --yes && apt install --yes \
    1password-cli \
    && rm --recursive --force /var/lib/apt/lists

COPY --from=builder /build/target/release/onepassword-exporter /usr/local/bin/onepassword-exporter

ENTRYPOINT ["onepassword-exporter"]
CMD ["--host", "0.0.0.0"]
