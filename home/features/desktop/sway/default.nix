{ lib, ... }:

{
  imports = [ ./sway.nix ];

  options.ft.desktop.sway = {
    enable = lib.mkEnableOption "Sway/SwayFX tiling Wayland compositor (home-manager)";

    monitor = lib.mkOption {
      type = lib.types.str;
      default = "*";
      description = ''
        Sway output identifier for monitor configuration.
        Use "*" to apply settings to all outputs (auto-detect).

        Examples:
          "*"                          — auto-detect everything, no scaling
          "eDP-1 resolution 1920x1080" — explicit laptop panel
          "HDMI-A-1 resolution 2560x1440 position 1920,0"
      '';
    };
  };
}
