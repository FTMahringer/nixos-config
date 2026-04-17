{ config, lib, pkgs, ... }:

lib.mkIf config.ft.desktop.hyprland.enable {

  # nixprism (enabled in daily-tools.nix) replaces rofi as the app launcher.
  # We keep rofi available as a system package since nixprism uses it internally,
  # but disable the home-manager rofi module to avoid config conflicts.
  programs.rofi = {
    enable = false;
  };

}
