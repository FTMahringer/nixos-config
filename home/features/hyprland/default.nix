{ lib, ... }:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./quickshell.nix
    ./rofi.nix
    ./mako.nix
    ./hyprlock.nix
    ./hypridle.nix
  ];

  options.ft.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland desktop environment (home-manager)";

    bar = lib.mkOption {
      type = lib.types.enum [ "waybar" "quickshell" ];
      default = "waybar";
      description = ''
        Bar/shell to use with Hyprland.
          "waybar"     — the classic Waybar status bar (default)
          "quickshell" — caelestia-dots/shell built on Quickshell
      '';
    };

    monitor = lib.mkOption {
      type = lib.types.str;
      default = ",preferred,auto,1";
      description = ''
        Hyprland monitor configuration string.  Format: "name,resolution,position,scale"
        Use "," (all commas, empty fields) for fully automatic detection.

        Examples:
          ",preferred,auto,1"            — auto detect everything, no HiDPI scaling
          "eDP-1,1920x1080@60,0x0,1.5"  — explicit laptop panel at 1.5× scale
          "HDMI-A-1,2560x1440@144,auto,1"
      '';
    };

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "Default terminal emulator command ($terminal in Hyprland).";
    };
  };
}
