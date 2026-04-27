{ config, lib, ... }:

lib.mkIf config.ft.desktop.enable {
  programs.ft-nixlaunch = {
    enable = true;

    # Pull colors from ft-nixpalette → Stylix → config.lib.stylix.colors.
    theme = "ft-nixpalette";

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    window = {
      width        = 680;
      borderRadius = 20;
    };

    iconSize   = 36;
    maxResults = 7;
    padding    = 24;
    spacing    = 12;

    searchEngine = "https://duckduckgo.com/?q=";
    browser      = "firefox";
    terminal     = "foot";
  };
}
