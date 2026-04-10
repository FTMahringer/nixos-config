{ inputs, ... }:

{
  imports = [
    ./programs
    ./shell
  ];

  home.username = "fynn";
  home.homeDirectory = "/home/fynn";
  home.stateVersion = "25.11";
}
