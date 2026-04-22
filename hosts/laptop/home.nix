{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Backup existing files that would be overwritten by Home Manager
  home-manager.backupFileExtension = "backup";

  home-manager.users.fynn = {
    imports = [ ../../home ];

    # Enable ft-nixpalette theming (auto-integration disabled to prevent infinite recursion)
    ft-nixpalette.enable = true;

    # Enable shared desktop features (mako, clipboard, screenshots, bar, etc.)
    ft.desktop.enable = true;

    # Structured home directory layout
    ft.homeDir.enable = true;
    # ft.homeDir.nixosConfigPath = /etc/nixos;  # default, change if your flake lives elsewhere

    # ── Desktop compositor selection ─────────────────────────────────────────
    # Pick ONE — mutually exclusive.
    #   "hyprland"  — Hyprland tiling Wayland compositor  ← default
    #   "mangowc"   — Mango compositor + Wayfire
    ft.desktop.compositor = "hyprland";

    # ── Bar selection ────────────────────────────────────────────────────────
    # "eww"    — ElKowar's Wacky Widgets (modern, highly customizable)  ← default
    # "waybar" — Classic Waybar status bar
    # "none"   — No bar
    ft.desktop.bar.backend = "eww";

    # Monitor config — adjust to your display.  Default = auto-detect, no scaling.
    # Example for a 4K display at 2× scale: "eDP-1,3840x2160@60,0x0,2"
    # ft.desktop.hyprland.monitor = ",preferred,auto,1";
    # ft.desktop.mangowc.monitor = ",preferred,auto,1";

    # Enable terminal emulators (toggle on/off here)
    ft.terminal.kitty.enable = true;
    ft.terminal.wezterm.enable = true;

    # Override shared terminal defaults if desired:
    # ft.terminal.defaults.padding = 16;
    # ft.terminal.defaults.scrollbackLines = 20000;
    # ft.terminal.defaults.cursorStyle = "block";
    # ft.terminal.defaults.cursorBlink = false;
  };
}
