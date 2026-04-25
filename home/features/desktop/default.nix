{ lib, config, ... }:

let
  cfg = config.ft.desktop;
in
{
  imports = [
    ./shared
    ./hyprland
    ./mangowc
    ./sway
    ./niri
    ./river
    ./launcher.nix
  ];

  options.ft.desktop.compositor = lib.mkOption {
    type = lib.types.enum [ "hyprland" "mangowc" "sway" "niri" "river" ];
    default = "hyprland";
    description = ''
      Desktop compositor / window manager to use.
      Pick exactly one — they are mutually exclusive.

      - "hyprland" — Hyprland tiling Wayland compositor          ← default
      - "mangowc"  — Mango compositor + Wayfire
      - "sway"     — Sway / SwayFX tiling Wayland compositor
      - "niri"     — Niri scrolling Wayland compositor
      - "river"    — River dynamic tiling Wayland compositor
    '';
  };

  # Automatically enable the selected compositor, disable all others
  config = {
    ft.desktop.hyprland.enable = lib.mkDefault (cfg.compositor == "hyprland");
    ft.desktop.mangowc.enable  = lib.mkDefault (cfg.compositor == "mangowc");
    ft.desktop.sway.enable     = lib.mkDefault (cfg.compositor == "sway");
    ft.desktop.niri.enable     = lib.mkDefault (cfg.compositor == "niri");
    ft.desktop.river.enable    = lib.mkDefault (cfg.compositor == "river");
  };
}
