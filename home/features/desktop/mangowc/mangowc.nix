{ config, lib, pkgs, ... }:

let
  cfg = config.ft.desktop.mangowc;
in
lib.mkIf cfg.enable {

  home.packages = with pkgs; [
    wayfire             # The Wayfire compositor
    wayfirePlugins.wf-shell   # Default Wayfire shell (background, panel, dock)
    wayfirePlugins.wcm        # Wayfire Config Manager GUI
    mangohud            # MangoHud — overlay for FPS, temps, etc.
  ];

  # ── Wayfire session wrapper ───────────────────────────────────────────────
  # We create a simple session script that starts Wayfire with Mango compositor
  # integration.  Mango is used as a post-processing / effects layer on top of
  # Wayfire.
  home.file.".local/bin/mango-session" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Mango + Wayfire session starter

      # Export standard Wayland environment
      export XDG_SESSION_TYPE=wayland
      export XDG_CURRENT_DESKTOP=wayfire
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export GDK_BACKEND=wayland,x11,*
      export MOZ_ENABLE_WAYLAND=1
      export XCURSOR_SIZE=24

      # Start clipboard history daemon
      wl-paste --type text  --watch cliphist store &
      wl-paste --type image --watch cliphist store &

      # Start the bar
      ${config.ft.desktop.bar.package} &

      # Start Wayfire compositor
      exec wayfire
    '';
  };

  # ── MangoHud configuration ────────────────────────────────────────────────
  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    # MangoHud overlay config
    fps
    frametime
    cpu_stats
    cpu_temp
    gpu_stats
    gpu_temp
    ram
    vram
    engine_version
    vulkan_driver
    wine
    arch
    no_display           # hide by default, toggle with key
    toggle_hud=Shift_R+F12
    background_alpha=0.5
    font_size=18
    position=top-left
    round_corners=1
    border_radius=5
  '';

  # ── Wayfire config ────────────────────────────────────────────────────────
  xdg.configFile."wayfire.ini".text = lib.generators.toINI {} {
    core = {
      plugins = "alpha animate autostart blur command cube decoration expo fade fire zoom grid idle invert move place resize scale switcher vswipe window-rules wobbly wrot";
      close_top_view = "<super> KEY_Q | alt KEY_F4";
      vwidth = 3;
      vheight = 3;
      preferred_decoration_mode = "client";
    };

    autostart = {
      "0" = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };

    decoration = {
      border_size = 2;
      title_height = 0;  # no title bar (clean look)
    };

    input = {
      xkb_layout = "de";
      kb_repeat_delay = 400;
      kb_repeat_rate = 40;
      natural_scroll = true;
      disable_while_typing = true;
      tap_to_click = true;
    };

    command = {
      # ── App launcher ──────────────────────────────────────────────────────
      binding_launcher = "<super> KEY_SPACE";
      command_launcher = "ft-nixlaunch";

      # ── Terminal ──────────────────────────────────────────────────────────
      binding_terminal = "<super> KEY_ENTER";
      command_terminal = config.ft.desktop.terminal;

      # ── Browser ───────────────────────────────────────────────────────────
      binding_browser = "<super> KEY_B";
      command_browser = "firefox";

      # ── File manager ──────────────────────────────────────────────────────
      binding_files = "<super> KEY_E";
      command_files = "${config.ft.desktop.terminal} -e yazi";

      # ── Screenshots ───────────────────────────────────────────────────────
      binding_screenshot_area   = "KEY_SYSRQ";
      command_screenshot_area   = "grim -g \"$(slurp)\" - | wl-copy";
      binding_screenshot_full   = "<super> KEY_SYSRQ";
      command_screenshot_full   = "grim - | wl-copy";
      binding_screenshot_save   = "<super> <shift> KEY_SYSRQ";
      command_screenshot_save   = "grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";

      # ── Lock screen ───────────────────────────────────────────────────────
      binding_lock = "<super> <shift> KEY_L";
      command_lock = "hyprlock";

      # ── Clipboard ─────────────────────────────────────────────────────────
      binding_clipboard = "<super> KEY_C";
      command_clipboard = "cliphist list | nixprism --dmenu | cliphist decode | wl-copy";

      # ── Audio ─────────────────────────────────────────────────────────────
      binding_vol_mute = "KEY_MUTE";
      command_vol_mute = "pamixer -t";
      binding_vol_up   = "KEY_VOLUMEUP";
      command_vol_up   = "pamixer -i 5";
      binding_vol_down = "KEY_VOLUMEDOWN";
      command_vol_down = "pamixer -d 5";

      # ── Brightness ───────────────────────────────────────────────────────
      binding_brightness_up   = "KEY_BRIGHTNESSUP";
      command_brightness_up   = "brightnessctl set 5%+";
      binding_brightness_down = "KEY_BRIGHTNESSDOWN";
      command_brightness_down = "brightnessctl set 5%-";
    };

    move = {
      activate = "<super> BTN_LEFT";
    };

    resize = {
      activate = "<super> BTN_RIGHT";
    };

    zoom = {
      activate = "<super> KEY_Z";
    };

    scale = {
      activate = "<super> KEY_A";
    };

    expo = {
      activate = "<super> KEY_E";
    };

    cube = {
      activate = "<ctrl> <alt> BTN_LEFT";
    };

    vswipe = {
      enable_horizontal = true;
      enable_vertical = true;
    };

    switcher = {
      activate = "<alt> KEY_TAB";
    };

    blur = {
      method = " kawase";
      radius = 5;
    };

    animate = {
      open_animation = "zoom";
      close_animation = "fade";
      duration = 300;
    };

    idle = {
      toggle = "<super> KEY_I";
    };

    window-rules = {
      rule_1 = "on created if title contains \"Picture-in-Picture\" then set floating";
    };
  };
}
