# 1password-exporter

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![codecov](https://codecov.io/gh/lasuillard-s/1password-exporter/graph/badge.svg?token=WTWCSXEMSR)](https://codecov.io/gh/lasuillard-s/1password-exporter)
[![Docker Image Version](https://img.shields.io/docker/v/lasuillard/1password-exporter?sort=semver)](https://hub.docker.com/r/lasuillard/1password-exporter)

Prometheus metrics exporter for 1Password.

## ✨ Features

1password-exporter is a Rust-based Prometheus exporter with these features:

- **Export metrics** from 1Password using the [`op` CLI](https://developer.1password.com/docs/cli/)
- **Collect comprehensive 1Password metrics** — account, user, group, vault, item, document, service account, and rate limit data, with build info embedded at compile time
- **Docker image for deployment** — includes OP CLI pre-installed

## 🚀 How to use

You have two options to use 1password-exporter: the binary CLI or the Docker image.

### ⌨️ Using the binary CLI

> [!NOTE]
> You should have 1Password CLI (`op`) installed and accessible.

Download the binary from the [GitHub Releases](https://github.com/lasuillard-s/1password-exporter/releases), and run:

```bash
$ export OP_EXPORTER_VERSION='v0.5.0'
$ wget --output-document=./onepassword-exporter "https://github.com/lasuillard-s/1password-exporter/releases/download/${OP_EXPORTER_VERSION}/onepassword-exporter-x86_64-unknown-linux-gnu" \
  && chmod +x ./onepassword-exporter
$ ./onepassword-exporter --help
A simple Prometheus exporter for the 1Password

Usage: onepassword-exporter [OPTIONS]

Options:
      --log-level <LOG_LEVEL>
          Log level [default: INFO]
      --host <HOST>
          Host to bind the server to [default: 127.0.0.1]
  -p, --port <PORT>
          Port to bind the server to [default: 9999]
  -m, --metrics <METRICS>...
          Metrics to collect. Only metrics that do not consume API rate limits are enabled by default [default: account group user service-account build-info] [possible values: account, build-info, group, service-account, user, document, item, vault]
      --op-path <OP_PATH>
          Path to 1Password CLI binary [default: op]
      --service-account-token <SERVICE_ACCOUNT_TOKEN>
          Service account token to pass to the 1Password CLI
  -h, --help
          Print help
  -V, --version
          Print version
```

### 🐳 Using Docker

The recommended launch option is using Docker. The image already includes OP CLI.

```bash
export OP_SERVICE_ACCOUNT_TOKEN="ops_ey..." # Used by the `op` CLI, not the exporter
docker container run --interactive --tty --rm \
  --env OP_SERVICE_ACCOUNT_TOKEN \
  --publish 127.0.0.1:9999:9999 \
  --init \
  lasuillard/1password-exporter:latest \
    --metrics account,vault,user,group
```

Metrics are now served at `http://localhost:9999/metrics`.

#### ⚙️ Environment variables

| Key | Description |
| --- | ----------- |

The exporter does not currently use any environment variables.

For more usage examples, including a sample Grafana dashboard, see the [examples](/examples) directory.

## 📏 Available Metrics

The exporter collects the following metrics via the 1Password CLI:

| Metric            | 1Password CLI command                       | Consumes quota |
| ----------------- | ------------------------------------------- | -------------- |
| `account`         | `op account get`                            | No             |
| `build-info`      | Embedded at build time                      | No             |
| `document`        | `op document list`                          | Yes (read)     |
| `group`           | `op group list`                             | No             |
| `item`            | `op item list`                              | Yes (read)     |
| `service-account` | `op whoami`, `op service-account ratelimit` | No             |
| `user`            | `op user list`                              | No             |
| `vault`           | `op vault list`                             | Yes (read)     |

See [`tests/expected_metrics.txt`](tests/expected_metrics.txt) for the full list of available metrics.

## ⚠️ Limitations

Due to how the OP CLI and the exporter work, there are several known limitations:

- The exporter can collect metrics from vaults that the service account can read.
- Newly created vaults will not be tracked because 1Password does not automatically grant service accounts access to new vaults. If you add a new vault, create a new service account and update the token.
- Some vaults, such as Private, cannot be shared with a service account, so metrics for those vaults cannot be collected.
- Metrics that consume quota (`document`, `item`, and `vault`) are subject to 1Password API rate limiting.

## 💖 Contributing

Please refer to [CONTRIBUTING.md](./CONTRIBUTING.md) for more information on how to contribute to this project.

## 📜 License

This project is licensed under the MIT License.
