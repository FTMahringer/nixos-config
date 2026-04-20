{ lib, config, ... }:

let
  cfg = config.ft.desktop;
in
{
  imports = [
    ./shared
    ./hyprland
    ./mangowc
  ];

  options.ft.desktop.compositor = lib.mkOption {
    type = lib.types.enum [ "hyprland" "mangowc" ];
    default = "hyprland";
    description = ''
      Desktop compositor / window manager to use.
      Pick exactly one — they are mutually exclusive.

      - "hyprland" — Hyprland tiling Wayland compositor
      - "mangowc"  — Mango compositor + Wayfire
    '';
  };

  # Automatically enable the selected compositor, disable the other
  config = {
    ft.desktop.hyprland.enable = lib.mkDefault (cfg.compositor == "hyprland");
    ft.desktop.mangowc.enable = lib.mkDefault (cfg.compositor == "mangowc");
  };
}
