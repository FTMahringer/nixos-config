{ config, pkgs, lib, ... }:

let
  cfg = config.ft.programs.river;
in
{
  options.ft.programs.river = {
    enable = lib.mkEnableOption "River dynamic tiling Wayland compositor (system-level)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      river
      polkit_gnome
      networkmanagerapplet
      brightnessctl
      playerctl
      pamixer
      pavucontrol
      libnotify
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
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
            --sessions ${pkgs.river}/share/wayland-sessions
        '';
        user = "greeter";
      };
    };

    users.users.fynn.extraGroups = [ "video" "audio" ];
  };
}
