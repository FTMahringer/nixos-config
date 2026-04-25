{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Backup existing files that would be overwritten by Home Manager
  home-manager.backupFileExtension = "backup";

  home-manager.users.fynn = {
    imports = [ ../../home ];

    # NOTE: ft-nixpalette is configured via the NixOS module (system-wide).
    # The HM module (homeModules.default) is for standalone HM usage only.
    # Do NOT enable ft-nixpalette here — it would conflict with the NixOS
    # module since both configure Stylix.

    # Enable shared desktop features (mako, clipboard, screenshots, bar, etc.)
    ft.desktop.enable = true;

    # Structured home directory layout
    ft.homeDir.enable = true;
    # ft.homeDir.nixosConfigPath = /etc/nixos;  # default, change if your flake lives elsewhere

    # ── Desktop compositor selection ─────────────────────────────────────────
    # Pick ONE — mutually exclusive.
    #   "hyprland"  — Hyprland tiling Wayland compositor  ← default
    #   "mangowc"   — Mango compositor + Wayfire
    #   "sway"      — Sway / SwayFX tiling Wayland compositor
    #   "niri"      — Niri scrolling Wayland compositor
    #   "river"     — River dynamic tiling Wayland compositor
    ft.desktop.compositor = "hyprland";

    # ── ft-nixlaunch compositor integration ──────────────────────────────────
    # Must match ft.desktop.compositor above.
    # ft-nixlaunch supported values: "Hyprland" | "Niri" | "GNOME" | "KDE" |
    #                                "COSMIC"   | "MangoWC" | null
    #
    # Notes on unsupported compositors:
    #   mangowc — ft-nixlaunch MangoWC integration writes Hyprland-style bind
    #             syntax; our stack uses Wayfire INI [command] plugin instead.
    #             Keybind already wired in wayfire.ini — use null here.
    #   sway    — no ft-nixlaunch sway integration; keybind in sway.nix.
    #   niri    — ft-nixlaunch Niri integration writes via
    #             programs.niri.settings.binds (nixpkgs HM module), which
    #             conflicts with our xdg.configFile approach — use null for
    #             now; keybind lives in niri/config.kdl directly.
    #   river   — no ft-nixlaunch integration; keybind in river init script.
    programs.ft-nixlaunch.compositor = "Hyprland";

    # Hyprland-specific launcher integration (only active when compositor = "Hyprland").
    # Injects into wayland.windowManager.hyprland.settings automatically:
    #   bind      = SUPER, space, exec, ft-nixlaunch
    #   layerrule = blur,        rofi
    #   layerrule = ignorezero,  rofi
    programs.ft-nixlaunch.integrations.hyprland = {
      keybind        = "SUPER, space";
      blurLayerRules = true;   # frosted-glass blur on the rofi layer surface
      dimAround      = false;  # set true for Spotlight-style dim behind launcher
    };

    # ── Bar selection ────────────────────────────────────────────────────────
    # "eww"    — ElKowar's Wacky Widgets (modern, highly customizable)  ← default
    # "waybar" — Classic Waybar status bar
    # "none"   — No bar
    ft.desktop.bar.backend = "eww";

    # ── Monitor config ───────────────────────────────────────────────────────
    # Adjust to your display.  Default = auto-detect, no scaling.
    # Example for a 4K display at 2× scale: "eDP-1,3840x2160@60,0x0,2"
    # ft.desktop.hyprland.monitor = ",preferred,auto,1";
    # ft.desktop.mangowc.monitor  = ",preferred,auto,1";
    # ft.desktop.sway.monitor     = "*";
    # ft.desktop.niri.monitor     = "auto";
    # ft.desktop.river.monitor    = "";

    # Enable terminal emulators (toggle on/off here)
    ft.terminal.kitty.enable   = true;
    ft.terminal.wezterm.enable = true;

    # Override shared terminal defaults if desired:
    # ft.terminal.defaults.padding        = 16;
    # ft.terminal.defaults.scrollbackLines = 20000;
    # ft.terminal.defaults.cursorStyle    = "block";
    # ft.terminal.defaults.cursorBlink    = false;
  };
}
