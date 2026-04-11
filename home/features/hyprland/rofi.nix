{ config, lib, pkgs, ... }:

lib.mkIf config.ft.desktop.hyprland.enable {

  programs.rofi = {
    enable = true;
    # rofi-wayland is the Wayland-native fork; required for Hyprland
    package = pkgs.rofi-wayland;

    # Stylix handles all color theming via stylix.targets.rofi.
    # We only configure layout and behavior here.
    extraConfig = {
      modi = "drun,run,window,filebrowser";
      show-icons = true;
      drun-display-format = "{name}";
      location = 0; # centered
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps";
      display-run = "   Run";
      display-window = "   Windows";
      display-filebrowser = "   Files";
      sidebar-mode = true;
      kb-cancel = "Escape,Super_L";
    };
  };
}
