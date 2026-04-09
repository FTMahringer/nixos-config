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
    ];
  };
}
