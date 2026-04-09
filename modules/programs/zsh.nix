{ config, pkgs, lib, ... }:

let
  cfg = config.ft.programs.zsh;
in
{
  options.ft.programs.zsh = {
    enable = lib.mkEnableOption = "Zsh";
  }

  config = lib.mkIf cfg.enable = {
    programs.zsh.enable = true;

    environment.systemvariables = with pkgs; [
      zsh
    ];
  };
}
