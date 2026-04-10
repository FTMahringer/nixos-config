{ inputs, ... }:

{
  imports = [
    ./features
  ];

  home = {
    username = "fynn";
    homeDirectory = "/home/fynn";
    stateVersion = "25.11";
  };
}
