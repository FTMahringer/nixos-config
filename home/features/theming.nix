{ config, lib, osConfig, ... }:
{
  # Mirror nixpalette settings from NixOS so the HM module can configure
  # stylix at user level. Required because stylix.homeManagerIntegration.autoImport
  # is disabled (to prevent double-import of the stylix HM module).
  nixpalette = {
    enable       = true;
    theme        = osConfig.nixpalette.theme;
    userThemeDir = osConfig.nixpalette.userThemeDir;
  };

  # ── nixpalette-hyprland (Hyprland-specific theming) ──────────────────────
  #
  # The nixpalette-hyprland HM module provides:
  #   hyprlock  — auto-generated lockscreen config (we use our own layout)
  #   waybar    — injects colors.css with @define-color for all base16 slots
  #   rofi/wofi — generates themed launcher configs
  #   switcher  — adds nixpalette-switch script for live theme switching
  #   swww      — animated wallpaper daemon (NixOS-side systemd service)
  nixpalette-hyprland = {
    hyprlock.enable = false; # we own hyprlock in home/features/hyprland/hyprlock.nix
    waybar.enable   = true;  # generate ~/.config/waybar/colors.css
  };

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
  #   hyprland                 → col.active_border, col.inactive_border, shadow color
  #   waybar                   → full base16 palette as @define-color CSS variables
  #   rofi                     → colors.rasi injected into rofi config
  #   mako                     → background/text/border/progress colors
  #
  # DISABLED (managed elsewhere):
  #   hyprpaper → swww (from nixpalette-hyprland) handles animated wallpaper;
  #     the swww systemd user service is configured at the NixOS level.
  #
  #   neovim / vim / nvf → NVF manages Neovim theming independently.
  #     Stylix has three separate neovim targets (neovim.nix, vim.nix, nvf.nix).
  #     All three must be disabled or NVF's vim.theme.name conflicts with
  #     the "gruvbox" theme set in home/features/nvim/settings.nix.
  #     To switch Neovim to Stylix/base16 theming instead:
  #       1. Set all three targets to true
  #       2. Remove the `vim.theme` block from settings.nix
  #
  #   hyprlock → We provide our own layout (blurred screenshot background,
  #     clock labels) in home/features/hyprland/hyprlock.nix and reference
  #     config.lib.stylix.colors directly for a fully custom look.

  stylix.targets = {
    neovim.enable   = false;
    vim.enable      = false;
    nvf.enable      = false;    # ← Stylix's dedicated NVF target (separate from neovim)
    hyprlock.enable = false;    # ← we own hyprlock in home/features/hyprland/hyprlock.nix
    hyprpaper.enable = lib.mkForce false;   # ← swww (nixpalette-hyprland) handles wallpaper
  };

  # GTK4 — HM 26.05 changed the default of gtk.gtk4.theme from
  # config.gtk.theme to null.  Setting it explicitly silences the warning
  # and adopts the new behaviour (GTK4 uses its own native theming;
  # Stylix themes GTK3 apps via gtk.theme).
  gtk.gtk4.theme = null;
}
