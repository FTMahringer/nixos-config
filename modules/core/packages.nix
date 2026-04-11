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
    ];
  };
}
