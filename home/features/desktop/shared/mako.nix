{ config, lib, ... }:

lib.mkIf config.ft.desktop.enable {

  services.mako = {
    enable = true;

    # Stylix handles colors AND font via stylix.targets.mako automatically.
    # We configure layout and behavior only.
    settings = {
      anchor = "top-right";
      sort = "-time";
      default-timeout = 5000; # ms — auto-dismiss after 5 s
      max-visible = 5;
      width = 380;
      height = 120;
      border-radius = 8;
      border-size = 2;
      margin = "10";
      padding = "12,16";
    };

    extraConfig = ''
      [urgency=critical]
      default-timeout=0
    '';
  };
}
