{ config, ... }:
{
  # Home-manager Stylix target overrides.
  #
  # nixpalette → Stylix (autoEnable = true) themes every supported HM app
  # automatically.  The targets below are the complete picture:
  #
  # AUTO-ENABLED (do nothing — nixpalette handles them):
  #   kitty                    → base16 colors, font, opacity
  #   wezterm                  → color_scheme, font, opacity, window chrome
  #   bat                      → syntax highlight theme
  #   fzf                      → --color options injected via env
  #   zsh-syntax-highlighting  → highlight colors from base16 palette
  #   starship                 → palette.stylix defined (we use #hex directly)
  #   yazi                     → theme.toml generated from base16
  #   gtk                      → GTK3 theme + icon theme
  #
  # DISABLED (app manages its own theme):
  #   neovim / vim / nvf → NVF manages Neovim theming independently.
  #     Stylix has three separate neovim targets (neovim.nix, vim.nix, nvf.nix).
  #     All three must be disabled or NVF's vim.theme.name conflicts with
  #     the "gruvbox" theme set in home/features/nvim/settings.nix.
  #     To switch Neovim to Stylix/base16 theming instead:
  #       1. Set all three targets to true
  #       2. Remove the `vim.theme` block from settings.nix

  stylix.targets = {
    neovim.enable = false;
    vim.enable    = false;
    nvf.enable    = false; # ← Stylix's dedicated NVF target (separate from neovim)
  };

  # GTK4 — HM 26.05 changed the default of gtk.gtk4.theme from
  # config.gtk.theme to null.  Setting it explicitly silences the warning
  # and adopts the new behaviour (GTK4 uses its own native theming;
  # Stylix themes GTK3 apps via gtk.theme).
  gtk.gtk4.theme = null;
}
