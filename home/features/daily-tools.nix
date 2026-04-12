{ config, lib, pkgs, inputs, ... }:

let
  # nixpalette → Stylix base16 colors
  c = config.lib.stylix.colors;

  # Zed settings with nixpalette theme overrides
  zedSettings = builtins.fromJSON (builtins.readFile ./settings/zed-settings.json);

  # Merge user's Zed settings with nixpalette theme overrides
  zedSettingsWithTheme = zedSettings // {
    # Use a base16-compatible theme
    theme = "One Dark";  # Base16 dark theme that works well with nixpalette

    # Override theme colors with nixpalette colors
    theme_overrides = {
      "One Dark" = {
        # Background - base00
        "background" = "#${c.base00}";
        "surface.background" = "#${c.base01}";
        "elevated_surface.background" = "#${c.base01}";
        "panel.background" = "#${c.base01}";
        "status_bar.background" = "#${c.base01}";
        "title_bar.background" = "#${c.base01}";
        "toolbar.background" = "#${c.base00}";
        "tab_bar.background" = "#${c.base01}";
        "tab.inactive_background" = "#${c.base01}";
        "tab.active_background" = "#${c.base00}";

        # Borders - base02
        "border" = "#${c.base02}";
        "border.variant" = "#${c.base02}";
        "border.focused" = "#${c.base0D}";
        "border.selected" = "#${c.base0D}";
        "panel.focused_border" = "#${c.base0D}";

        # Text - base05
        "text" = "#${c.base05}";
        "text.muted" = "#${c.base04}";
        "text.placeholder" = "#${c.base03}";
        "text.disabled" = "#${c.base03}";
        "text.accent" = "#${c.base0D}";

        # Accents - base16 colors
        "accent" = "#${c.base0D}";  # Blue
        "accent.hover" = "#${c.base0C}";  # Cyan

        # Status colors
        "error" = "#${c.base08}";  # Red
        "warning" = "#${c.base0A}";  # Yellow
        "success" = "#${c.base0B}";  # Green
        "info" = "#${c.base0D}";  # Blue

        # Syntax highlighting (base16 colors)
        "syntax.comment" = { "color" = "#${c.base03}"; "font_style" = "italic"; };
        "syntax.comment.doc" = { "color" = "#${c.base03}"; "font_style" = "italic"; };
        "syntax.keyword" = "#${c.base0E}";  # Purple
        "syntax.function" = "#${c.base0D}";  # Blue
        "syntax.string" = "#${c.base0B}";  # Green
        "syntax.type" = "#${c.base0A}";  # Yellow
        "syntax.variable" = "#${c.base05}";  # White
        "syntax.constant" = "#${c.base09}";  # Orange
        "syntax.property" = "#${c.base08}";  # Red
        "syntax.operator" = "#${c.base05}";  # White

        # Players (multiplayer cursors)
        "players" = [
          { "cursor" = "#${c.base08}"; "background" = "#${c.base08}"; "selection" = "#${c.base08}"; }
          { "cursor" = "#${c.base09}"; "background" = "#${c.base09}"; "selection" = "#${c.base09}"; }
          { "cursor" = "#${c.base0A}"; "background" = "#${c.base0A}"; "selection" = "#${c.base0A}"; }
          { "cursor" = "#${c.base0B}"; "background" = "#${c.base0B}"; "selection" = "#${c.base0B}"; }
          { "cursor" = "#${c.base0C}"; "background" = "#${c.base0C}"; "selection" = "#${c.base0C}"; }
          { "cursor" = "#${c.base0D}"; "background" = "#${c.base0D}"; "selection" = "#${c.base0D}"; }
          { "cursor" = "#${c.base0E}"; "background" = "#${c.base0E}"; "selection" = "#${c.base0E}"; }
          { "cursor" = "#${c.base0F}"; "background" = "#${c.base0F}"; "selection" = "#${c.base0F}"; }
        ];

        # Terminal colors (base16)
        "terminal.background" = "#${c.base00}";
        "terminal.foreground" = "#${c.base05}";
        "terminal.black" = "#${c.base00}";
        "terminal.red" = "#${c.base08}";
        "terminal.green" = "#${c.base0B}";
        "terminal.yellow" = "#${c.base0A}";
        "terminal.blue" = "#${c.base0D}";
        "terminal.magenta" = "#${c.base0E}";
        "terminal.cyan" = "#${c.base0C}";
        "terminal.white" = "#${c.base05}";
        "terminal.bright_black" = "#${c.base03}";
        "terminal.bright_red" = "#${c.base08}";
        "terminal.bright_green" = "#${c.base0B}";
        "terminal.bright_yellow" = "#${c.base0A}";
        "terminal.bright_blue" = "#${c.base0D}";
        "terminal.bright_magenta" = "#${c.base0E}";
        "terminal.bright_cyan" = "#${c.base0C}";
        "terminal.bright_white" = "#${c.base07}";
      };
    };
  };
in
{
  # Daily essential applications
  home.packages = with pkgs; [
    # --- Web Browsers ---
    brave
    firefox

    # --- Communication ---
    element-desktop  # Matrix client
    webcord          # Lightweight Discord client

    # --- Documents & Office ---
    obsidian
    libreoffice

    # --- Media ---
    spotify
    imv              # Minimal image viewer for Wayland

    # --- System Utilities ---
    pavucontrol      # PulseAudio volume control GUI
    blueman          # Bluetooth manager
    networkmanagerapplet # Network manager tray icon
    gnome-calculator # Calculator
    btop             # System monitor (pretty)

    # --- Development Tools ---
    vscodium         # VS Code without Microsoft telemetry
    zed-editor       # Modern Rust-based editor
    jetbrains.idea-community  # IntelliJ IDEA Community Edition
    # Note: For other JetBrains tools, use individual packages like:
    # jetbrains.pycharm-community (or pycharm-professional)
    # jetbrains.webstorm
    # jetbrains.rust-rover
    # jetbrains-toolbox is not recommended on NixOS - use individual packages instead
    jq               # JSON processor
    fx               # Terminal JSON viewer

    # --- Security ---
    bitwarden-desktop

    # --- Mail ---
    thunderbird
  ];

  # --- Tell stylix which profiles to theme ---
  stylix.targets.firefox.profileNames = [ "default" ];

  # --- Zed Editor Configuration ---
  # Uses your settings with nixpalette theme overrides
  xdg.configFile."zed/settings.json".text = lib.mkDefault (builtins.toJSON zedSettingsWithTheme);

  # --- Browser Configuration ---
  # Firefox configuration via Home Manager
  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "default";
      isDefault = true;
      settings = {
        # Privacy & Security
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.send_pings" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        # Disable telemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        # UI tweaks
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1; # Compact UI
        # Enable hardware acceleration
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
      };
      # Search engines
      search = {
        default = "ddg";
        force = true;
      };
    };
  };

  # --- Thunderbird Configuration ---
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        # General settings
        "general.useragent.compatMode.firefox" = true;
        # Privacy
        "privacy.donottrackheader.enabled" = true;
        # Disable telemetry
        "toolkit.telemetry.enabled" = false;
      };
    };
  };

  # --- Spotifyd (optional terminal Spotify client) ---
  # Uncomment if you want spotifyd + spotify-tui instead of official Spotify
  # services.spotifyd = {
  #   enable = true;
  #   settings = {
  #     global = {
  #       username = "your_username";
  #       password_cmd = "pass spotify";
  #       backend = "pulseaudio";
  #       device_name = "nixos-desktop";
  #     };
  #   };
  # };

  # --- imv configuration ---
  # Uses nixpalette base00 (background) color
  xdg.configFile."imv/config".text = ''
    [options]
    # Window background color (nixpalette base00 - background)
    background = ${c.base00}
    # Scale mode: full, crop, shrink, none
    scale = shrink
    # Loop through images
    loop = yes
    # Show status bar
    overlay = yes
    # Status bar format
    overlay_font = monospace:12
    overlay_text = $imv_current_file [$imv_widthx$imv_height] ($imv_scale%)

    [aliases]
    # Define aliases for commands
    q = quit
    n = next
    p = prev
    f = fullscreen

    [binds]
    # Vim-style navigation
    h = prev
    l = next
    j = pan 0 -50
    k = pan 0 50
    # Zoom
    plus = zoom 1
    minus = zoom -1
    # Rotate
    r = rotate by 90
    R = rotate by -90
    # Flip
    x = flip horizontal
    y = flip vertical
    # Other
    f = fullscreen
    d = overlay
    p = exec echo $imv_current_file
  '';

  # --- btop configuration ---
  # Note: btop theme is already handled by nixpalette/stylix (sets "stylix" theme)
  # We just enable additional settings here
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      vim_keys = true;
      rounded_corners = true;
      graph_symbol = "braille";
      update_ms = 1000;
    };
  };
}
