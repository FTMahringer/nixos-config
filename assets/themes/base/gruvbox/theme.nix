# Gruvbox Dark Medium — retro groove color scheme.
# https://github.com/morhetz/gruvbox  (base16 mapping by dawikur/base16-gruvbox-scheme)
{
  polarity = "dark";

  base16 = {
    base00 = "282828"; # bg        — hard background
    base01 = "3c3836"; # bg1       — lighter background / status bar
    base02 = "504945"; # bg2       — selection background
    base03 = "665c54"; # bg3       — comments, invisibles
    base04 = "bdae93"; # bg4       — light background / cursor line
    base05 = "d5c4a1"; # fg1       — default foreground
    base06 = "ebdbb2"; # fg2       — light foreground
    base07 = "fbf1c7"; # fg3       — lightest foreground
    base08 = "fb4934"; # red       — variables, tags
    base09 = "fe8019"; # orange    — integers, constants
    base0A = "fabd2f"; # yellow    — classes, search text
    base0B = "b8bb26"; # green     — strings
    base0C = "8ec07c"; # aqua      — support, regex
    base0D = "83a598"; # blue      — functions, attributes
    base0E = "d3869b"; # purple    — keywords
    base0F = "d65d0e"; # brown     — deprecated, special
  };

  fonts = {
    serif = {
      name    = "Noto Serif";
      package = "noto-fonts";
    };
    sansSerif = {
      name    = "Inter";
      package = "inter";
    };
    # Regular JetBrains Mono — ft.theming.stylixOverrides promotes this to
    # the Nerd Font variant system-wide, so icon glyphs work everywhere.
    monospace = {
      name    = "JetBrains Mono";
      package = "jetbrains-mono";
    };
    emoji = {
      name    = "Noto Color Emoji";
      package = "noto-fonts-color-emoji";
    };
    sizes = {
      applications = 12;
      desktop      = 11;
      popups       = 10;
      terminal     = 13;
    };
  };

  # Wallpaper: set to a path (e.g. ./wallpaper.png) to bundle one with the theme.
  # null → Stylix auto-generates a wallpaper from the base16 palette.
  wallpaper = null;

  overrides = {};
}
