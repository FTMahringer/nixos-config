{ config, lib, osConfig, ... }:
{
  # ft-nixpalette theming is handled by the NixOS ft-nixpalette module.
  # The Home-Manager ft-nixpalette module has enableStylix = false to avoid
  # duplicate Stylix definitions. All stylix.targets are configured system-wide.

  # GTK4 native theming
  gtk.gtk4.theme = null;
}
