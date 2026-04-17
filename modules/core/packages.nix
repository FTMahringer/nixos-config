{ config, pkgs, lib, ... }:

let
  cfg = config.ft.core.packages;
in
{
  options.ft.core.packages = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable default core packages.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      curl
      wget
      htop
      tree
      fastfetch
      # SSL tooling — needed so the Nix daemon can verify TLS when
      # fetching flake inputs from GitHub and other HTTPS sources.
      openssl
      cacert
      # Age encryption — used by sops-nix to encrypt/decrypt secrets
      age
      # Node.js — required for Zed's ACP (Agent Client Protocol) registry agents.
      # Zed spawns npm/npx internally to install adapters for Claude, Codex, etc.
      # Without node in the global PATH, registry agents fail silently.
      nodejs
    ];
  };
}
