{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules
    ];

  networking.hostName = "ft-nixos";

  users.users.fynn = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  ft.programs.neovim.enable = true;
  # ft.programs.git.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?
}

