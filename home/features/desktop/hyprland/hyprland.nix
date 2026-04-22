{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.ft.desktop.hyprland;
  hyprlandPkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
in
lib.mkIf cfg.enable {

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprlandPkg;
    xwayland.enable = true;
    # Integrate Hyprland with systemd so that graphical-session.target starts,
    # which in turn starts mako, hypridle, and other services.
    systemd.enable = true;

    settings = {
      monitor = [ "${cfg.monitor}" ];

      "$mod" = "SUPER";
      "$terminal" = config.ft.desktop.terminal;
      "$fileManager" = "${config.ft.desktop.terminal} -e yazi";
      "$menu" = "ft-nixlaunch";

      # ── Startup ─────────────────────────────────────────────────────────────
      # mako / hypridle / hyprpaper start as systemd user services.
      # Only things without a proper systemd unit go here.
      exec-once = [
        "nm-applet --indicator"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "wl-paste --type text  --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      # ── Environment ─────────────────────────────────────────────────────────
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "QT_QPA_PLATFORM,wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "GDK_BACKEND,wayland,x11,*"
        "MOZ_ENABLE_WAYLAND,1"
      ];

      # ── Layout & gaps ───────────────────────────────────────────────────────
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
        # border colors are set by Stylix (col.active_border / col.inactive_border)
      };

      # ── Decoration ──────────────────────────────────────────────────────────
      decoration = {
        rounding = 8;
        active_opacity = 1.0;
        inactive_opacity = 0.92;

        blur = {
          enabled = true;
          size = 8;
          passes = 2;
          new_optimizations = true;
          xray = false;
        };

        shadow = {
          enabled = true;
          range = 10;
          render_power = 3;
          # shadow color is set by Stylix
        };
      };

      # ── Animations ──────────────────────────────────────────────────────────
      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint, 0.23, 1,    0.32, 1"
          "easeInOut,    0.65, 0.05, 0.35, 1"
          "linear,       0,    0,    1,    1"
        ];

        animation = [
          "windows,    1, 5,  easeOutQuint, slide"
          "windowsOut, 1, 4,  easeInOut,    slide"
          "border,     1, 10, default"
          "fade,       1, 7,  default"
          "workspaces, 1, 5,  easeOutQuint, slidevert"
        ];
      };

      # ── Tiling layout ───────────────────────────────────────────────────────
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # ── Input ───────────────────────────────────────────────────────────────
      input = {
        kb_layout = "de"; # matches system XKB layout in modules/core/base.nix
        follow_mouse = 1;
        sensitivity = 0; # 0 = no acceleration

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
          drag_lock = false;
        };
      };

      gestures = {
        # workspace_swipe / workspace_swipe_fingers were removed; use gesture keyword instead
        workspace_swipe_invert = true;
      };

      # 3-finger horizontal swipe → switch workspace (replaces removed workspace_swipe)
      gesture = [ "3, horizontal, workspace" ];

      # ── Ecosystem ───────────────────────────────────────────────────────────
      ecosystem = {
          no_donation_nag = true;
          no_update_news = true;
      };

      # ── Misc ────────────────────────────────────────────────────────────────
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      # ── Keybindings ─────────────────────────────────────────────────────────
      bind = [
        # Apps
        "$mod, Return, exec, $terminal"
        "$mod, E,      exec, $fileManager"
        "$mod, Space,  exec, $menu"
        "$mod, B,      exec, firefox"

        # Window management
        "$mod,       Q, killactive"
        "$mod SHIFT, Q, exit"
        "$mod,       F, fullscreen"

        "$mod,       V, togglefloating"
        "$mod,       P, pseudo"
        "$mod,       J, layoutmsg, togglesplit"

        # Focus movement (vim-style)
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Move windows
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        # Workspace switching
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Special (scratchpad) workspace
        "$mod,       S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace,        special:magic"

        # Workspace scroll (keyboard)
        "$mod, right, workspace, e+1"
        "$mod, left,  workspace, e-1"

        # Workspace scroll (mouse wheel on desktop)
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up,   workspace, e-1"

        # Screenshots
        ",      Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod,  Print, exec, grim - | wl-copy"
        "$mod SHIFT, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"

        # Clipboard history (nixprism picker)
        "$mod, C, exec, cliphist list | nixprism --dmenu | cliphist decode | wl-copy"

        # Lock screen
        "$mod, L, exec, hyprlock"

        # Audio
        ", XF86AudioMute,    exec, pamixer -t"
        ", XF86AudioMicMute, exec, pamixer --default-source -t"

        # Media keys
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"

        # Brightness
        ", XF86MonBrightnessUp,   exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      # Repeating binds (held key)
      binde = [
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
      ];

      # Mouse binds
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Cursor: disable hardware cursors to fix cursor vanishing on hover
      cursor = {
        no_hardware_cursors = true;
      };

      # ── Window rules ────────────────────────────────────────────────────────
      # windowrulev2 was deprecated; new syntax uses windowrule with match: props
      windowrule = [
        "suppress_event maximize, match:class .*"
        "float on, match:class nm-connection-editor"
        "float on, match:class pavucontrol"
        "float on, match:class blueman-manager"
        "float on, match:title Picture-in-Picture"
        "pin on, match:title Picture-in-Picture"
        "float on, match:class org.gnome.Nautilus, match:title Properties"
      ];
    };
  };
}
