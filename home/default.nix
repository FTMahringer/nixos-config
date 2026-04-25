{ inputs, ... }:
{
  imports = [
    ./features
    inputs.ft-nixpkgs.homeModules.ft-nixpalette
  ];

  home = {
    username = "fynn";
    homeDirectory = "/home/fynn";
    stateVersion = "25.11";
  };
}
