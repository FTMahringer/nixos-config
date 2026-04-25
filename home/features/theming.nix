{ config, lib, osConfig, ... }:
{
  # ft-nixpalette is NixOS-only. Stylix runs system-wide and auto-propagates
  # to Home-Manager via stylix.homeManagerIntegration (default: true).
  # config.lib.stylix.colors is available in HM for custom theming.

  # GTK4 native theming
  gtk.gtk4.theme = null;
}
