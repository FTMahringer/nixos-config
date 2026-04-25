{ lib, ... }:

{
  imports = [
    ./niri.nix
  ];

  options.ft.desktop.niri = {
    enable = lib.mkEnableOption "Niri scrolling Wayland compositor (home-manager)";

    monitor = lib.mkOption {
      type = lib.types.str;
      default = "auto";
      description = ''
        Niri output/monitor name for explicit configuration.
        Use "auto" to let niri detect all outputs automatically.

        Examples:
          "auto"                                — auto-detect everything
          "eDP-1"                               — explicit laptop panel name
          "HDMI-A-1"                            — explicit HDMI output name
      '';
    };

    scale = lib.mkOption {
      type = lib.types.float;
      default = 1.0;
      description = ''
        HiDPI output scale factor.
        Examples: 1.0 (no scaling), 1.5 (1.5× HiDPI), 2.0 (2× HiDPI)
      '';
    };
  };
}
