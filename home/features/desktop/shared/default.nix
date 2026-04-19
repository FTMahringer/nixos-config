{ lib, ... }:

{
  imports = [
    ./mako.nix
    ./screenshots.nix
    ./clipboard.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./bar.nix
  ];

  options.ft.desktop = {
    enable = lib.mkEnableOption "desktop environment shared features (home-manager)";

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "Default terminal emulator command.";
    };
  };
}
