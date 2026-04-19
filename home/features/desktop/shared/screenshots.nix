{ config, lib, pkgs, ... }:

lib.mkIf config.ft.desktop.enable {

  home.packages = with pkgs; [
    grim   # Screenshot (full screen or region)
    slurp  # Interactive region selector for grim
  ];
}
