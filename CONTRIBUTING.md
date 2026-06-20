# ❤️‍🔥 Contributing to this project

Thank you for your interest in contributing to **1password-exporter**.

## 🐛 Reporting issues

Please report issues in our [GitHub repository](https://github.com/lasuillard-s/1password-exporter/issues). Before submitting an issue, please search for existing issues to avoid duplicates.

## 🏗️ Project overview

This project is a Prometheus exporter for 1Password. It uses the [1Password CLI](https://developer.1password.com/docs/cli/) internally to gather metrics and serve them over HTTP.

### 🛠️ Tech stack

This project uses the following tech stack:

- [Rust](https://www.rust-lang.org) 2021 edition
- [clap](https://docs.rs/clap/latest/clap/) for CLI argument parsing
- [hyper](https://hyper.rs/) to serve metrics over HTTP
- [rustfmt](https://github.com/rust-lang/rustfmt), [clippy](https://doc.rust-lang.org/clippy/), [cargo-nextest](https://nexte.st/) and [Miri](https://github.com/rust-lang/miri) for code quality and testing

### 📂 Key directory structure

- `examples/`: Usage examples (e.g., Grafana dashboard)
- `src/`: Rust source code
- `tests/`: Integration tests
- `Cargo.toml`: Project dependencies and configuration
- `Dockerfile`: Docker image definition
- `flake.nix`: Nix Flakes development environment
- `Justfile`: Commands for development
- `rust-toolchain.toml`: Rust toolchain configuration

## 🔧 Set up the development environment

This repository uses [Nix Flakes](https://nix.dev/concepts/flakes.html) to manage development tools. The following tools are installed automatically when `nix` is available:

- `pre-commit`
- `just`
- `rustup`
- `cargo`
- `cargo-llvm-cov`
- `cargo-nextest`
- `cargo-watch`
- `_1password-cli`

Run `nix develop` to enter the development environment, then run `just install` to set up the dependencies and toolchain. The Nix shell also installs the pre-commit hooks automatically.

If you prefer using a [Dev Container](https://containers.dev), an example configuration file ([`devcontainer.json`](./.devcontainer.example/devcontainer.json)) is provided with Nix pre-installed.

## ✅ Verifying changes

Before pushing your code, run `just ci` to verify that your changes adhere to the project's coding standards and pass all linters, formatters, coverage, and tests.

Alternatively, let the `pre-commit` hooks handle formatting, linting, and quick test feedback automatically.

## ✨ Submitting changes

Please submit pull requests on GitHub. Before opening a PR, make sure your changes pass all checks by running `just ci`.

## 🚀 Release process

1password-exporter is published to Docker Hub on pushes to the `main` branch and tagged pushes (`v*`). For a versioned release, follow these steps:

1. Dispatch [Prepare Release](https://github.com/lasuillard-s/1password-exporter/actions/workflows/prepare-release.yaml) workflow with the new version (e.g. `v0.1.0`)
1. Review and merge the PR created by the workflow
1. Create and publish a new release in GitHub Releases; this also creates the tag
1. The release workflow will automatically build and publish the Docker image
