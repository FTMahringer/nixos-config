{ config, lib, inputs, ... }:

{
  # Import the caelestia-shell home-manager module so its options are available.
  # The module is a no-op unless programs.caelestia-shell.enable = true.
  imports = [ inputs.caelestia-shell.homeModules.default ];

  config = lib.mkIf (config.ft.desktop.hyprland.enable && config.ft.desktop.hyprland.bar == "quickshell") {
    programs.caelestia = {
      enable = true;
      cli.enable = true;
    };
  };
}
