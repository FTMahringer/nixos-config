{ inputs, ... }:

{
  imports = [
    ./git.nix
    ./desktop
    ./nvim
    ./shell
    ./terminal
    ./theming.nix
    ./ai-tools.nix
    ./daily-tools.nix
    ./general-dev.nix
  ];
}
