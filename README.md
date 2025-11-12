# 1password-exporter

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![codecov](https://codecov.io/gh/lasuillard-s/1password-exporter/graph/badge.svg?token=WTWCSXEMSR)](https://codecov.io/gh/lasuillard-s/1password-exporter)
[![Docker Image Version](https://img.shields.io/docker/v/lasuillard/1password-exporter?sort=semver)](https://hub.docker.com/r/lasuillard/1password-exporter)

1Password personal (not Connect) usage exporter.

## ℹ️ About

This project is hobby-dev Prometheus metrics exporter for 1Password built with Rust. It collects several metrics via `op` CLI.

## 📦 Installation

The exporter provides download option as binary and Docker image.

### ⌨️ Using binary CLI

> [!NOTE]
> You should have 1Password CLI (`op`) installed in your machine and reachable to binary work.

To use binary, download it from releases and run:

```bash
$ OP_EXPORTER_VERSION="..." wget -qO ./onepassword-exporter "https://github.com/lasuillard/1password-exporter/releases/download/${OP_EXPORTER_VERSION}/onepassword-exporter-x86_64-unknown-linux-musl"
$ chmod +x ./onepassword-exporter
$ ./onepassword-exporter --help
A simple Prometheus exporter for the 1Password

Usage: onepassword-exporter [OPTIONS]

...
```

### 🐳 Using Docker

The recommended launch option is using Docker. The image already includes OP CLI.

```bash
export OP_SERVICE_ACCOUNT_TOKEN="ops_ey..."
docker container run -it --rm -e OP_SERVICE_ACCOUNT_TOKEN -p 9999:9999 --init lasuillard/1password-exporter:latest
```

Now metrics served at `http://localhost:9999/metrics`. You can find more, such as example Grafana dashboard, at [examples](/examples) directory.

## 📏 Available Metrics

See [test](/tests/expected_metrics.txt) file for expected metrics output to see all available metrics.

## ⚠️ Limitations

Due to how the OP CLI and the exporter works, there are several known limitations:

- Exporter can collect metrics from vaults SA has read access.
- Any newly created vaults won't be tracked because 1Password does not support automatic access grant for SA to newly created vaults. If you added new vault, you should create new SA and update the SA token.
- Some vaults (e.g. Private) is impossible to share with SA, therefore metrics for those vaults cannot be collected.

## 💖 Contributing

Please submit issues or pull requests for questions, bugs, or requests for new features.

## 📜 License

This project is licensed under the terms of the MIT license.
