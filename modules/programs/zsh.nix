{ config, pkgs, lib, ... }:

let
  cfg = config.ft.programs.zsh;
in
{
  options.ft.programs.zsh = {
    enable = lib.mkEnableOption "Zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      # nix-your-shell: keeps your shell when using nix shell
      interactiveShellInit = ''
        if command -v nix-your-shell > /dev/null; then
          nix-your-shell zsh | source /dev/stdin
        fi
      '';
    };

    environment.systemPackages = with pkgs; [
      zsh
      nix-your-shell
    ];

    # Make zsh the default shell for users
    users.defaultUserShell = pkgs.zsh;
  };
}
