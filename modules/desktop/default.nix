{ config, lib, ... }:

let
  cfg = config.ft.desktop;

  # ft-nixpalette DE names (null = no integration for that compositor)
  paletteDeMap = {
    "hyprland" = "Hyprland";
    "mangowc"  = "MangoWC";
    "niri"     = "Niri";
    "sway"     = null;
    "river"    = null;
  };
  paletteDe = paletteDeMap.${cfg.compositor} or null;
in
{
  options.ft.desktop = {
    compositor = lib.mkOption {
      type = lib.types.enum [ "hyprland" "mangowc" "sway" "niri" "river" ];
      default = "hyprland";
      description = ''
        Desktop compositor / window manager to use.  Setting this once here
        drives all system-level compositor enablement (greetd, pipewire,
        portals, etc.) and ft-nixpalette DE integration automatically.

        The same option must be mirrored in home-manager (ft.desktop.compositor)
        via hosts/<host>/home.nix — that is handled automatically when
        home.nix is a NixOS module that reads config.ft.desktop.compositor.

        Supported values:
          "hyprland" — Hyprland tiling Wayland compositor  (default)
          "mangowc"  — Mango compositor + Wayfire
          "sway"     — Sway / SwayFX tiling Wayland compositor
          "niri"     — Niri scrolling Wayland compositor
          "river"    — River dynamic tiling Wayland compositor
      '';
    };
  };

  config = {
    # ── System compositor enablement ────────────────────────────────────────
    ft.programs.hyprland.enable = lib.mkDefault (cfg.compositor == "hyprland");
    ft.programs.niri.enable     = lib.mkDefault (cfg.compositor == "niri");
    ft.programs.sway.enable     = lib.mkDefault (cfg.compositor == "sway");
    ft.programs.mangowc.enable  = lib.mkDefault (cfg.compositor == "mangowc");
    ft.programs.river.enable    = lib.mkDefault (cfg.compositor == "river");

    # ── ft-nixpalette DE color integration ──────────────────────────────────
    ft-nixpalette.integrations.de = lib.mkDefault paletteDe;
  };
}
