{ ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules
    ];

  networking.hostName = "ft-nixos";

  users.users.fynn = {
    isNormalUser = true;
    description = "Fynn";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  #ft.programs.neovim.enable = true;
  ft.programs.git.enable = true;
  ft.programs.zsh.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?
}

