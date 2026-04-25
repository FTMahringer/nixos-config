{ config, lib, pkgs, ... }:

let
  cfg      = config.ft.desktop.sway;
  modifier = "Mod4";
in
lib.mkIf cfg.enable {

  wayland.windowManager.sway = {
    enable  = true;
    # wrapperFeatures.gtk makes GTK apps (file pickers, etc.) work properly
    wrapperFeatures.gtk = true;
    # Integrate with systemd so graphical-session.target starts services like mako
    systemd.enable = true;

    config = {
      inherit modifier;

      # Terminal and menu are pulled from shared ft.desktop options
      terminal = config.ft.desktop.terminal;
      menu     = "ft-nixlaunch";

      # ── Input ─────────────────────────────────────────────────────────────
      input = {
        "type:keyboard" = {
          xkb_layout     = "de";
          repeat_delay    = "400";
          repeat_rate     = "40";
        };

        "type:touchpad" = {
          natural_scroll = "enabled";
          dwt            = "enabled";   # disable while typing
          tap            = "enabled";
          drag_lock      = "disabled";
        };
      };

      # ── Layout & gaps ──────────────────────────────────────────────────────
      gaps = {
        inner        = 5;
        outer        = 10;
        smartBorders = "on";
        smartGaps    = true;
      };

      window = {
        border         = 2;
        hideEdgeBorders = "smart";
      };

      floating = {
        border   = 2;
        criteria = [
          { app_id = "nm-connection-editor"; }
          { app_id = "pavucontrol"; }
          { app_id = "blueman-manager"; }
          { title  = "Picture-in-Picture"; }
        ];
      };

      # ── Bar ───────────────────────────────────────────────────────────────
      # ft.desktop.bar manages the bar (eww / waybar) — don't let sway add its own.
      bars = [ ];

      # ── Startup ───────────────────────────────────────────────────────────
      startup = [
        { command = "nm-applet --indicator"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        { command = "wl-paste --type text  --watch cliphist store"; }
        { command = "wl-paste --type image --watch cliphist store"; }
        # Start the status bar (eww or waybar, configured by ft.desktop.bar)
        { command = config.ft.desktop.bar.package; }
      ];

      # ── Keybindings ───────────────────────────────────────────────────────
      # Mirror the hyprland keybind set as closely as sway allows.
      keybindings = lib.mkOptionDefault {
        # Apps
        "${modifier}+Return"  = "exec ${config.ft.desktop.terminal}";
        "${modifier}+space"   = "exec ft-nixlaunch";
        "${modifier}+b"       = "exec firefox";
        "${modifier}+e"       = "exec ${config.ft.desktop.terminal} -e yazi";

        # Window management
        "${modifier}+q"         = "kill";
        "${modifier}+Shift+q"   = "exit";
        "${modifier}+f"         = "fullscreen toggle";
        "${modifier}+v"         = "floating toggle";
        "${modifier}+p"         = "layout toggle split";
        "${modifier}+j"         = "layout tabbed";

        # Focus (vim-style)
        "${modifier}+h" = "focus left";
        "${modifier}+l" = "focus right";
        "${modifier}+k" = "focus up";
        "${modifier}+j" = "focus down";

        # Move windows
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+l" = "move right";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+j" = "move down";

        # Workspace switching
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        # Move window to workspace
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        # Scratchpad
        "${modifier}+s"       = "scratchpad show";
        "${modifier}+Shift+s" = "move scratchpad";

        # Workspace scroll
        "${modifier}+right" = "workspace next";
        "${modifier}+left"  = "workspace prev";

        # Screenshots
        "Print"                   = "exec grim -g \"$(slurp)\" - | wl-copy";
        "${modifier}+Print"       = "exec grim - | wl-copy";
        "${modifier}+Shift+Print" = "exec grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";

        # Clipboard history (nixprism)
        "${modifier}+c" = "exec cliphist list | nixprism --dmenu | cliphist decode | wl-copy";

        # Lock screen
        "${modifier}+Shift+Escape" = "exec hyprlock";

        # Audio
        "XF86AudioMute"        = "exec pamixer -t";
        "XF86AudioMicMute"     = "exec pamixer --default-source -t";
        "XF86AudioRaiseVolume" = "exec pamixer -i 5";
        "XF86AudioLowerVolume" = "exec pamixer -d 5";

        # Media
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioNext" = "exec playerctl next";

        # Brightness
        "XF86MonBrightnessUp"   = "exec brightnessctl set 5%+";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
      };
    };

    # ── SwayFX extras ─────────────────────────────────────────────────────────
    # These lines require SwayFX (a Sway fork with visual effects).
    # On plain Sway they are silently ignored, so safe to include regardless.
    extraConfig = ''
      # SwayFX — blur rofi / ft-nixlaunch layer surface
      blur enable
      layer_effects "rofi" blur enable
      layer_effects "rofi" ignorealpha 0.0

      # Rounded corners (matches ft-nixlaunch borderRadius default of 20 px)
      corner_radius 8

      # Dim inactive windows slightly (matches Hyprland inactive_opacity = 0.92)
      default_dim_inactive 0.08
    '';
  };
}
