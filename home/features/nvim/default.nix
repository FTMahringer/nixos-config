{ inputs, ... }:

{
  imports = [
    inputs.nvf.homeManagerModules.default
    ./settings.nix
  ];
}
