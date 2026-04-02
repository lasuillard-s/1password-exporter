#!/usr/bin/env bash

ARCH="$(dpkg --print-architecture)"

# 1Password CLI
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg \
  && echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/${ARCH} stable main" | sudo tee /etc/apt/sources.list.d/1password.list

sudo apt-get update && sudo apt-get install -y \
  1password-cli

# cargo-binstall
curl --proto '=https' --tlsv1.2 --silent --fail --show-error --location https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
    | bash

# Download dev tools binaries
cargo binstall -y --log-level debug \
    cargo-llvm-cov \
    cargo-nextest \
    cargo-udeps \
    cargo-watch \
    cargo-insta
