{ lib, ... }:

{
  imports = [
    ./river.nix
  ];

  options.ft.desktop.river = {
    enable = lib.mkEnableOption "River tiling Wayland compositor (home-manager)";

    monitor = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Output name to configure.  Leave empty for auto-detection.

        Examples:
          ""         — auto-detect (no explicit output rule)
          "eDP-1"    — laptop built-in panel
          "HDMI-A-1" — external monitor
      '';
    };

    layout = lib.mkOption {
      type = lib.types.enum [ "rivertile" "stacktile" ];
      default = "rivertile";
      description = ''
        Layout generator to use with River.

        - "rivertile"  — built-in tiling layout (main + stack, configurable ratio)
        - "stacktile"  — alternative stack-based layout (requires the stacktile package)
      '';
    };

    mainRatio = lib.mkOption {
      type = lib.types.float;
      default = 0.6;
      description = ''
        Ratio of screen width given to the main area (rivertile).
        Must be between 0.0 and 1.0.
      '';
    };

    mainCount = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = ''
        Number of windows in the main area (rivertile).
      '';
    };
  };
}
