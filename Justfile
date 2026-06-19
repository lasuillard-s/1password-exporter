_default:
    just --list

# Install deps and tools
install:
    rustup install
    rustup component add --toolchain nightly miri
    cargo fetch

# Update deps and tools
update:
    rustup update
    cargo update
    pre-commit autoupdate

alias up := update

# =============================================================================
# Development
# =============================================================================

# Run all checks
ci: lint ub-check test

# Autoformat code
format:
    rustup run nightly cargo fmt

alias fmt := format

# Run all linters
lint:
    rustup run nightly cargo fmt --check
    cargo clippy --all-targets --all-features -- --deny warnings

# Run Undefined Behavior Check (Miri)
ub-check:
    MIRIFLAGS='-Zmiri-disable-isolation' \
        rustup run nightly cargo miri nextest run --workspace --all-targets --all-features

# Run all tests
test:
    cargo llvm-cov nextest --workspace --all-targets --all-features --lcov --output-path lcov.info
    cargo llvm-cov report --summary-only

# Apply autofixes
fix:
    cargo clippy --all-targets --all-features --fix --allow-dirty --allow-no-vcs -- --deny warnings
    rustup run nightly cargo fmt

# Build the application
build:
    cargo build --release

# Build the Docker image (1password-exporter:local)
build-docker:
    docker build --tag 1password-exporter:local .

# Run application in dev mode
run *args="--help":
    cargo watch --exec 'run -- {{args}}'

# Build and run application Docker image
run-docker *args="--help": build-docker
    docker run --interactive --tty --rm 1password-exporter:local -- '{{args}}'

# =============================================================================
# Utility
# =============================================================================

# Remove temporary files
clean:
    rm --recursive --force target/ lcov.info
    find . -path '*.log*' -delete
