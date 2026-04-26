{ config, lib, ... }:

let
  cfg = config.ft.desktop;

  # Maps ft.desktop.compositor → programs.ft-nixlaunch.compositor.
  # Compositors without a ft-nixlaunch integration (sway, river, mangowc) map
  # to null so ft-nixlaunch manages its own keybind manually via the config file.
  ftlCompositorMap = {
    "hyprland" = "Hyprland";
    "niri"     = "Niri";
    "mangowc"  = null; # uses Wayfire INI [command] plugin keybind instead
    "sway"     = null; # no ft-nixlaunch sway integration
    "river"    = null; # no ft-nixlaunch integration
  };
in
lib.mkIf cfg.enable {
  programs.ft-nixlaunch = {
    enable = true;

    # ── Compositor integration ───────────────────────────────────────────────
    # Derived automatically from ft.desktop.compositor — no need to set this
    # separately in hosts/<host>/home.nix.
    compositor = ftlCompositorMap.${cfg.compositor} or null;

    # ── Colors ──────────────────────────────────────────────────────────────
    nixpaletteIntegration = true;

    # ── Font ────────────────────────────────────────────────────────────────
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    # ── Window ──────────────────────────────────────────────────────────────
    window = {
      width        = 680;
      borderRadius = 20;
    };

    # ── Layout ──────────────────────────────────────────────────────────────
    iconSize   = 36;
    maxResults = 7;
    padding    = 24;
    spacing    = 12;

    # ── Behavior ────────────────────────────────────────────────────────────
    searchEngine = "https://duckduckgo.com/?q=";
    browser      = "firefox";
    terminal     = "foot";
  };
}
