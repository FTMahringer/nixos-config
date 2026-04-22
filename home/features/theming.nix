{ config, lib, osConfig, ... }:

let
  nixpaletteCfg = osConfig.ft-nixpalette or { };
in
{
  # Mirror ft-nixpalette settings from NixOS so the HM module can configure
  # stylix at user level. Required because stylix.homeManagerIntegration.autoImport
  # is disabled (to prevent double-import of the stylix HM module).
  nixpalette = {
    enable       = true;
    theme        = nixpaletteCfg.theme or "builtin:base/catppuccin-mocha";
    userThemeDir = nixpaletteCfg.userThemeDir or null;
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
    hyprlock.enable = false; # we own hyprlock in home/features/desktop/
    waybar.enable   = lib.mkIf (config.ft.desktop.bar.backend or "waybar" == "waybar") true;
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
  #   mako                     → background/text/border/progress colors
  #
  # DISABLED (managed elsewhere):
  #   hyprpaper → swww (from nixpalette-hyprland) handles animated wallpaper;
  #     the swww systemd user service is configured at the NixOS level.
  #
  #   neovim / vim → not used (we use nvf, not programs.neovim/vim).
  #
  #   nvf → Stylix's dedicated NVF target auto-generates a base16 colorscheme
  #     from the active nixpalette theme, so Neovim always matches the rest
  #     of the desktop.  The `vim.theme` block must not be set in settings.nix.
  #
  #   hyprlock → We provide our own layout (blurred screenshot background,
  #     clock labels) in home/features/desktop/hyprland/hyprlock.nix and reference
  #     config.lib.stylix.colors directly for a fully custom look.

  stylix.targets = {
    neovim.enable   = false;
    vim.enable      = false;
    nvf.enable      = true;     # ← Stylix themes Neovim via nvf using nixpalette colors
    hyprlock.enable = false;    # ← we own hyprlock in home/features/desktop/
    hyprpaper.enable = lib.mkForce false;   # ← swww (nixpalette-hyprland) handles wallpaper
  };

  # GTK4 — HM 26.05 changed the default of gtk.gtk4.theme from
  # config.gtk.theme to null.  Setting it explicitly silences the warning
  # and adopts the new behaviour (GTK4 uses its own native theming;
  # Stylix themes GTK3 apps via gtk.theme).
  gtk.gtk4.theme = null;
}
