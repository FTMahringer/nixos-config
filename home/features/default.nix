{ inputs, ... }:

{
  imports = [
    ./git.nix
    ./nvim
    ./shell
    ./terminal
    ./theming.nix
  ];
}
