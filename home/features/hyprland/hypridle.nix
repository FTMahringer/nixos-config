{ config, lib, ... }:

lib.mkIf config.ft.desktop.hyprland.enable {

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # don't spawn multiple instances
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 300; # 5 min → lock screen
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600; # 10 min → turn off display
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
