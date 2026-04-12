{ inputs, ... }:

{
  imports = [
    inputs.nvf.homeModules.default
    ./settings.nix
  ];
}
