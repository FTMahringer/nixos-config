{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.ft.programs.niri;
  niriPkg = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
in
{
  options.ft.programs.niri = {
    enable = lib.mkEnableOption "Niri scrolling Wayland compositor (system-level)";
  };

  config = lib.mkIf cfg.enable {
    # Install niri from the flake for the pinned version
    environment.systemPackages = [
      niriPkg
      pkgs.polkit_gnome
      pkgs.networkmanagerapplet
      pkgs.brightnessctl
      pkgs.playerctl
      pkgs.pamixer
      pkgs.pavucontrol
      pkgs.libnotify
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      config.common.default = "*";
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;

    security.polkit.enable = true;

    services.greetd = {
      enable = true;
      settings.default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --time \
            --remember \
            --sessions ${niriPkg}/share/wayland-sessions
        '';
        user = "greeter";
      };
    };

    users.users.fynn.extraGroups = [ "video" "audio" ];
  };
}
