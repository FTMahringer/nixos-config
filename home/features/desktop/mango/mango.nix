{ config, lib, pkgs, ... }:

let
  cfg = config.ft.desktop.mango;
in
lib.mkIf cfg.enable {

  # wayland.windowManager.mango is provided by inputs.mango.hmModules.mango
  # imported in flake.nix.
  wayland.windowManager.mango = {
    enable = true;

    settings = lib.generators.toINI {} {
      core = {
        close_top_view = "<super> KEY_Q | alt KEY_F4";
        vwidth = 3;
        vheight = 3;
        preferred_decoration_mode = "client";
      };

      decoration = {
        border_size = 2;
        title_height = 0;
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
        binding_launcher = "<super> KEY_SPACE";
        command_launcher = "ft-nixlaunch";

        binding_terminal = "<super> KEY_ENTER";
        command_terminal = config.ft.desktop.terminal;

        binding_browser = "<super> KEY_B";
        command_browser = "firefox";

        binding_files = "<super> KEY_E";
        command_files = "${config.ft.desktop.terminal} -e yazi";

        binding_screenshot_area = "KEY_SYSRQ";
        command_screenshot_area = "grim -g \"$(slurp)\" - | wl-copy";
        binding_screenshot_full = "<super> KEY_SYSRQ";
        command_screenshot_full = "grim - | wl-copy";
        binding_screenshot_save = "<super> <shift> KEY_SYSRQ";
        command_screenshot_save = "grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";

        binding_lock = "<super> <shift> KEY_L";
        command_lock = "hyprlock";

        binding_clipboard = "<super> KEY_C";
        command_clipboard = "cliphist list | nixprism --dmenu | cliphist decode | wl-copy";

        binding_vol_mute = "KEY_MUTE";
        command_vol_mute = "pamixer -t";
        binding_vol_up   = "KEY_VOLUMEUP";
        command_vol_up   = "pamixer -i 5";
        binding_vol_down = "KEY_VOLUMEDOWN";
        command_vol_down = "pamixer -d 5";

        binding_brightness_up   = "KEY_BRIGHTNESSUP";
        command_brightness_up   = "brightnessctl set 5%+";
        binding_brightness_down = "KEY_BRIGHTNESSDOWN";
        command_brightness_down = "brightnessctl set 5%-";
      };

      move    = { activate = "<super> BTN_LEFT"; };
      resize  = { activate = "<super> BTN_RIGHT"; };
      zoom    = { activate = "<super> KEY_Z"; };
      scale   = { activate = "<super> KEY_A"; };
      expo    = { activate = "<super> KEY_W"; };
      cube    = { activate = "<ctrl> <alt> BTN_LEFT"; };
      switcher = { activate = "<alt> KEY_TAB"; };

      vswipe = {
        enable_horizontal = true;
        enable_vertical = true;
      };

      blur = {
        method = "kawase";
        radius = 5;
      };

      animate = {
        open_animation  = "zoom";
        close_animation = "fade";
        duration = 300;
      };

      idle  = { toggle = "<super> KEY_I"; };

      window-rules = {
        rule_1 = "on created if title contains \"Picture-in-Picture\" then set floating";
      };
    };

    autostart_sh = ''
      ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
      nm-applet --indicator &
      wl-paste --type text  --watch cliphist store &
      wl-paste --type image --watch cliphist store &
      ${config.ft.desktop.bar.package} &
    '';
  };

  xdg.configFile."MangoHud/MangoHud.conf".text = ''
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
    no_display
    toggle_hud=Shift_R+F12
    background_alpha=0.5
    font_size=18
    position=top-left
    round_corners=1
    border_radius=5
  '';

  home.packages = with pkgs; [ mangohud ];
}
