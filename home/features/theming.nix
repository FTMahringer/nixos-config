{ config, lib, osConfig, ... }:
{
  # ft-nixpalette is NixOS-only. Stylix runs system-wide and auto-propagates
  # to Home-Manager via stylix.homeManagerIntegration (default: true).
  # config.lib.stylix.colors is available in HM for custom theming.

  # GTK4 native theming
  gtk.gtk4.theme = null;

  # hyprlock is themed manually in desktop/shared/hyprlock.nix using
  # config.lib.stylix.colors directly — disable Stylix's auto-integration
  # so it doesn't conflict with our background definition.
  stylix.targets.hyprlock.enable = false;

  # Tell Stylix which Firefox profile to theme (matches the profile declared
  # in daily-tools.nix) and keep the legacy ~/.mozilla/firefox config path.
  stylix.targets.firefox.profileNames = [ "default" ];
  programs.firefox.configPath = ".mozilla/firefox";
}
