{ lib, ... }:

{
  imports = [
    ./mangowc.nix
  ];

  options.ft.desktop.mangowc = {
    enable = lib.mkEnableOption "Mango compositor + Wayfire desktop environment (home-manager)";

    monitor = lib.mkOption {
      type = lib.types.str;
      default = ",preferred,auto,1";
      description = ''
        Monitor configuration string.  Format: "name,resolution,position,scale"
        Use "," (all commas, empty fields) for fully automatic detection.
      '';
    };
  };
}
