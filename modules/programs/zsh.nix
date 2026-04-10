{ config, pkgs, lib, ... }:

let
  cfg = config.ft.programs.zsh;
in
{
  options.ft.programs.zsh = {
    enable = lib.mkEnableOption "Zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;

    # nix-your-shell: keeps your shell when using nix shell
    programs.nix-your-shell = {
      enable = true;
      shell = "zsh";
    };

    environment.systemPackages = with pkgs; [
      zsh
    ];

    # Make zsh the default shell for users
    users.defaultUserShell = pkgs.zsh;
  };
}
