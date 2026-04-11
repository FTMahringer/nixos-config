{ inputs, ... }:

{
  imports = [
    ./git.nix
    ./hyprland
    ./nvim
    ./shell
    ./terminal
    ./theming.nix
  ];
}
