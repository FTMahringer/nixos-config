{ config, pkgs, lib, ... }:

let
  cfg = config.ft.programs.git;
in
{
  options.ft.programs.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Git.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
    };

    environment.systemPackages = with pkgs; [
      git
    ];
  };
}
