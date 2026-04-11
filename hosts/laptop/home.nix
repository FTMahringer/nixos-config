{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Backup existing files that would be overwritten by Home Manager
  home-manager.backupFileExtension = "backup";

  home-manager.users.fynn = {
    imports = [ ../../home ];

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
