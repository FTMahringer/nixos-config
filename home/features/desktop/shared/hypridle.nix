{ config, lib, ... }:

let
  cfg = config.ft.desktop;

  # Pick the right DPMS command based on which compositor is active.
  # hyprctl works on Hyprland; wlr-randr is the generic wlroots fallback.
  dpmsOff = if cfg.hyprland.enable or false
    then "hyprctl dispatch dpms off"
    else "wlr-randr --output eDP-1 --off";
  dpmsOn = if cfg.hyprland.enable or false
    then "hyprctl dispatch dpms on"
    else "wlr-randr --output eDP-1 --on";
in
lib.mkIf cfg.enable {

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # don't spawn multiple instances
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = dpmsOn;
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 300; # 5 min → lock screen
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600; # 10 min → turn off display
          on-timeout = dpmsOff;
          on-resume = dpmsOn;
        }
      ];
    };
  };
}
