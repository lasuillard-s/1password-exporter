use clap::Parser;
use simplelog::*;

use crate::metrics_collector::Metrics;

mod command_executor;
mod metrics_collector;
mod server;

#[cfg(test)]
mod testing;

#[cfg(test)]
#[path = "../tests/test_helper.rs"]
pub(crate) mod test_helper;

/// A simple Prometheus exporter for the 1Password.
#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    /// Log level.
    #[arg(long, default_value_t = LevelFilter::Info)]
    log_level: LevelFilter,

    /// Host to bind the server to.
    #[arg(long, default_value = "127.0.0.1")]
    host: String,

    /// Port to bind the server to.
    #[arg(short, long, default_value_t = 9999)]
    port: u16,

    /// Metrics to collect. Only metrics that do not consume API rate limits are enabled by default
    #[arg(short, long, num_args = 1.., value_delimiter = ',', default_values = ["account", "group", "user", "service-account", "build-info"])]
    metrics: Vec<Metrics>,

    /// Path to 1Password CLI binary.
    #[arg(long, default_value = "op")]
    op_path: String,

    /// Service account token to pass to the 1Password CLI.
    #[arg(long)]
    service_account_token: Option<String>,
}

async fn _main(args: Args) -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    TermLogger::init(
        args.log_level,
        Config::default(),
        TerminalMode::Mixed,
        ColorChoice::Auto,
    )?;
    crate::server::run_server(
        args.host,
        args.port,
        args.metrics,
        args.op_path,
        args.service_account_token,
    )
    .await
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    let args = Args::parse();
    _main(args).await
}
