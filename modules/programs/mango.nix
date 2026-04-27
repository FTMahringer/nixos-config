{ config, pkgs, lib, ... }:

let
  cfg = config.ft.programs.mango;
in
{
  options.ft.programs.mango = {
    enable = lib.mkEnableOption "Mango compositor (system-level)";
  };

  config = lib.mkIf cfg.enable {
    # programs.mango is provided by inputs.mango.nixosModules.mango imported
    # in flake.nix — it installs the mango package and wayland session file.
    programs.mango.enable = true;

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
            --cmd mango
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
