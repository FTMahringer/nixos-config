{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Backup existing files that would be overwritten by Home Manager
  home-manager.backupFileExtension = "backup";

  home-manager.users.fynn = {
    imports = [ ../../home ];

    # Hyprland desktop environment
    ft.desktop.hyprland.enable = true;
    # Monitor config — adjust to your display.  Default = auto-detect, no scaling.
    # Example for a 4K display at 2× scale: "eDP-1,3840x2160@60,0x0,2"
    # ft.desktop.hyprland.monitor = ",preferred,auto,1.5";

    # Enable terminal emulators (toggle on/off here)
    ft.terminal.kitty.enable = true;
    ft.terminal.wezterm.enable = true;

    # Override shared terminal defaults if desired:
    # ft.terminal.defaults.padding = 16;
    # ft.terminal.defaults.scrollbackLines = 20000;
    # ft.terminal.defaults.cursorStyle = "block";
    # ft.terminal.defaults.cursorBlink = false;
  };
}
