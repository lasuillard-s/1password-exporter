{
  pkgs ? import <nixpkgs> { 
    config = {
      # Allow 1Password CLI installation
      allowUnfree = true;
    };
  },
}:

# System requirements: Docker with compose plugin

pkgs.mkShell {
  packages = [
    pkgs.git
    pkgs.gnumake
    pkgs.pre-commit
    pkgs.rustup
    pkgs.cargo
    pkgs.cargo-llvm-cov
    pkgs.cargo-nextest
    pkgs.cargo-udeps
    pkgs.cargo-watch
    pkgs.cargo-insta
    pkgs._1password-cli
  ];
}
