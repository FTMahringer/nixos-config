{ config, lib, pkgs, ... }:

let
  cfg = config.ft.desktop.niri;

  # Build an explicit output block only when a real monitor name is given.
  # If monitor = "auto" we let niri discover everything on its own.
  outputBlock =
    if cfg.monitor == "auto" then ""
    else ''
      output "${cfg.monitor}" {
          scale ${toString cfg.scale}
      }
    '';
in
lib.mkIf cfg.enable {

  # ── Packages ──────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    niri
    xwayland-satellite          # XWayland support for niri
    grim slurp                  # screenshots
    wl-clipboard                # wl-copy / wl-paste
    pamixer brightnessctl       # audio + backlight
    playerctl                   # media keys
    cliphist                    # clipboard manager
    polkit_gnome                # authentication agent
  ];

  # ── niri config (KDL) ─────────────────────────────────────────────────────
  xdg.configFile."niri/config.kdl".text = ''
    // ── Input ────────────────────────────────────────────────────────────────
    input {
        keyboard {
            xkb {
                layout "de"
            }
            repeat-delay 400
            repeat-rate 40
        }

        touchpad {
            tap
            natural-scroll
            dwt                 // disable-while-typing
            accel-speed 0.0
            accel-profile "flat"
        }

        mouse {
            accel-speed 0.0
            accel-profile "flat"
        }
    }

    // ── Output / monitor ─────────────────────────────────────────────────────
    ${outputBlock}

    // ── Layout ───────────────────────────────────────────────────────────────
    layout {
        gaps 10

        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 2
        }

        border {
            off
        }

        struts {
            left   0
            right  0
            top    0
            bottom 0
        }
    }

    // ── Cursor ────────────────────────────────────────────────────────────────
    cursor {
        xcursor-size 24
    }

    // ── Environment ───────────────────────────────────────────────────────────
    environment {
        QT_QPA_PLATFORM                  "wayland"
        QT_WAYLAND_DISABLE_WINDOWDECORATION "1"
        GDK_BACKEND                      "wayland,x11,*"
        MOZ_ENABLE_WAYLAND               "1"
        XCURSOR_SIZE                     "24"
        DISPLAY                          ":0"    // for xwayland-satellite
    }

    // ── Startup ───────────────────────────────────────────────────────────────
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "nm-applet" "--indicator"
    spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    spawn-at-startup "wl-paste" "--type" "text"  "--watch" "cliphist" "store"
    spawn-at-startup "wl-paste" "--type" "image" "--watch" "cliphist" "store"
    spawn-at-startup "bash" "-c" "${config.ft.desktop.bar.package}"

    // ── Prefer client-side decorations ───────────────────────────────────────
    prefer-no-csd

    // ── Keybindings ───────────────────────────────────────────────────────────
    binds {
        // ── Apps ────────────────────────────────────────────────────────────
        Mod+Return { spawn "${config.ft.desktop.terminal}"; }
        Mod+Space  { spawn "ft-nixlaunch"; }
        Mod+B      { spawn "firefox"; }
        Mod+E      { spawn "${config.ft.desktop.terminal}" "-e" "yazi"; }

        // ── Window management ────────────────────────────────────────────────
        Mod+Q       { close-window; }
        Mod+Shift+Q { quit; }
        Mod+F       { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+V       { toggle-window-floating; }

        // ── Focus (vim-style) ────────────────────────────────────────────────
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+K { focus-window-up; }
        Mod+J { focus-window-down; }

        // ── Move windows ─────────────────────────────────────────────────────
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+J { move-window-down; }

        // ── Resize columns ───────────────────────────────────────────────────
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }

        // ── Workspace switching ───────────────────────────────────────────────
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+0 { focus-workspace 10; }

        // ── Move to workspace ────────────────────────────────────────────────
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        Mod+Shift+0 { move-column-to-workspace 10; }

        // ── Scroll between workspaces ─────────────────────────────────────────
        Mod+Right { focus-workspace-down; }
        Mod+Left  { focus-workspace-up; }

        // ── Screenshots ───────────────────────────────────────────────────────
        Print            { screenshot; }
        Mod+Print        { screenshot-screen; }
        Mod+Shift+Print  { screenshot-window; }

        // ── Clipboard history ─────────────────────────────────────────────────
        Mod+C { spawn "bash" "-c" "cliphist list | nixprism --dmenu | cliphist decode | wl-copy"; }

        // ── Lock screen ───────────────────────────────────────────────────────
        Mod+Shift+L { spawn "hyprlock"; }

        // ── Audio ─────────────────────────────────────────────────────────────
        XF86AudioMute    allow-when-locked=true { spawn "pamixer" "-t"; }
        XF86AudioMicMute allow-when-locked=true { spawn "pamixer" "--default-source" "-t"; }
        XF86AudioRaiseVolume allow-when-locked=true { spawn "pamixer" "-i" "5"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "pamixer" "-d" "5"; }

        // ── Media ─────────────────────────────────────────────────────────────
        XF86AudioPlay { spawn "playerctl" "play-pause"; }
        XF86AudioPrev { spawn "playerctl" "previous"; }
        XF86AudioNext { spawn "playerctl" "next"; }

        // ── Brightness ────────────────────────────────────────────────────────
        XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "set" "5%+"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "5%-"; }
    }

    // ── Window rules ──────────────────────────────────────────────────────────
    window-rule {
        match app-id="nm-connection-editor"
        open-floating true
    }

    window-rule {
        match app-id="pavucontrol"
        open-floating true
    }

    window-rule {
        match app-id="blueman-manager"
        open-floating true
    }

    window-rule {
        match app-id="org.gnome.Nautilus" title="Properties"
        open-floating true
    }

    window-rule {
        match title="Picture-in-Picture"
        open-floating true
        default-floating-position x=16 y=16 relative-to="bottom-right"
    }
  '';
}
