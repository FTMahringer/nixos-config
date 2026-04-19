{ config, lib, pkgs, ... }:

lib.mkIf config.ft.desktop.enable {

  home.packages = with pkgs; [
    wl-clipboard  # wl-copy / wl-paste for Wayland clipboard
    cliphist      # Clipboard history manager
  ];
}
