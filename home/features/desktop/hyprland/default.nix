{ lib, ... }:

{
  imports = [
    ./hyprland.nix
  ];

  options.ft.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland desktop environment (home-manager)";

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
  };
}
