{ config, pkgs, lib, ... }:

let
  cfg = config.ft.programs.sway;
in
{
  options.ft.programs.sway = {
    enable = lib.mkEnableOption "Sway/SwayFX tiling Wayland compositor (system-level)";
  };

  config = lib.mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

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
            --sessions ${pkgs.sway}/share/wayland-sessions
        '';
        user = "greeter";
      };
    };

    environment.systemPackages = with pkgs; [
      polkit_gnome
      networkmanagerapplet
      brightnessctl
      playerctl
      pamixer
      pavucontrol
      libnotify
    ];

    users.users.fynn.extraGroups = [ "video" "audio" ];
  };
}
