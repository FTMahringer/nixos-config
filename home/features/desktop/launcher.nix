{ config, lib, ... }:

# ── ft-nixlaunch — shared appearance & behavior defaults ────────────────────
# This file owns everything that is the same across all hosts:
# font, window geometry, layout, web search, terminal, color integration.
#
# What does NOT live here:
#   compositor         — set in hosts/<host>/home.nix alongside ft.desktop.compositor
#   integrations.*     — set in hosts/<host>/home.nix (keybind, blur rules, etc.)
#
# This keeps the host file as the single place where all compositor-related
# choices are made, mirroring how ft-nixpalette.integrations.de lives in
# hosts/<host>/configuration.nix.
# ────────────────────────────────────────────────────────────────────────────
lib.mkIf config.ft.desktop.enable {
  programs.ft-nixlaunch = {
    enable = true;

    # ── Colors ──────────────────────────────────────────────────────────────
    # Pull colors from ft-nixpalette → Stylix → config.lib.stylix.colors.
    # ft-nixpalette is a NixOS-level module; Stylix auto-propagates to HM.
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
