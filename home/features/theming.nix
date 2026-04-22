{ config, lib, osConfig, ... }:
{
  # ft-nixpalette home-manager configuration is automatically handled
  # by the ft-nixpalette NixOS module when ft.theming.enable = true.
  # No manual configuration needed here.

  # Home-manager Stylix target overrides
  stylix.targets = {
    neovim.enable    = false;
    vim.enable       = false;
    nvf.enable       = true;
    hyprlock.enable  = false;
    hyprpaper.enable = lib.mkForce false;
  };

  # GTK4 native theming
  gtk.gtk4.theme = null;
}
