{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Point the Nix daemon at the system CA certificate bundle.
  # Without this, `nix build` / `nix flake update` can fail with
  # SSL_R_TLSV1_UNRECOGNIZED_NAME when fetching inputs from GitHub.
  nix.settings.ssl-cert-file = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

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
