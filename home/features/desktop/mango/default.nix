{ lib, ... }:

{
  imports = [ ./mango.nix ];

  options.ft.desktop.mango = {
    enable = lib.mkEnableOption "Mango compositor (home-manager)";
  };
}
