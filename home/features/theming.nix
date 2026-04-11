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
  #
  # DISABLED (app manages its own theme):
  #   neovim / vim → NVF manages Neovim theming; enabling Stylix alongside
  #                  NVF causes option conflicts.  To switch to Stylix for
  #                  Neovim, remove the theme block in home/features/nvim/
  #                  and set both targets to true.

  stylix.targets = {
    neovim.enable = false;
    vim.enable    = false;
  };
}
