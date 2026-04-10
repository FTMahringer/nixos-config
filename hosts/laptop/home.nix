{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Backup existing files that would be overwritten by Home Manager
  home-manager.backupFileExtension = "backup";

  home-manager.users.fynn = import ../../home;
}
