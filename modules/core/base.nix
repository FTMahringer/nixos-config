{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "de_AT.UTF-8";

  i18n.extraLocaleSettings.LC_ALL = "de_AT.UTF-8";

  # Console keyboard layout (German)
  console.keyMap = "de";

  # X11 keyboard layout (German) - applies to Wayland too via XKB
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  networking.networkmanager.enable = true;

  services.openssh.enable = true;
}
