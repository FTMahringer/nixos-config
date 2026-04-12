{ config, lib, pkgs, inputs, ... }:

let
  # nixpalette → Stylix base16 colors
  c = config.lib.stylix.colors;
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
    lazygit          # Terminal git UI
    zed-editor       # Modern Rust-based editor
    # Note: For JetBrains tools, use individual packages like:
    jetbrains.idea #(or idea-community)
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

  # --- Git Configuration for lazygit ---
  # Uses nixpalette/stylix base16 colors for automatic theme matching
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          # base0D = blue (active elements, options)
          activeBorderColor = [ "#${c.base0D}" "bold" ];
          optionsTextColor = [ "#${c.base0D}" ];
          cherryPickedCommitFgColor = [ "#${c.base0D}" ];
          # base03 = dark gray (inactive elements)
          inactiveBorderColor = [ "#${c.base03}" ];
          # base02 = darker background (selection backgrounds)
          selectedLineBgColor = [ "#${c.base02}" ];
          selectedRangeBgColor = [ "#${c.base02}" ];
          cherryPickedCommitBgColor = [ "#${c.base02}" ];
          # base08 = red (unstaged changes, errors)
          unstagedChangesColor = [ "#${c.base08}" ];
          # base05 = foreground/text
          defaultFgColor = [ "#${c.base05}" ];
        };
        showIcons = true;
        nerdFontsVersion = "3";
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        commit = {
          signOff = false;
        };
      };
      os = {
        editPreset = "nvim";
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
