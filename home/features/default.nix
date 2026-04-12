{ inputs, ... }:

{
  imports = [
    ./git.nix
    ./hyprland
    ./nvim
    ./shell
    ./terminal
    ./theming.nix
    ./ai-tools.nix
  ];
}
