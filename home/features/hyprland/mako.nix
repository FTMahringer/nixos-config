{ config, lib, ... }:

lib.mkIf config.ft.desktop.hyprland.enable {

  services.mako = {
    enable = true;

    # Stylix handles colors AND font via stylix.targets.mako automatically.
    # We configure layout and behavior only.
    anchor = "top-right";
    sort = "-time";
    defaultTimeout = 5000; # ms — auto-dismiss after 5 s
    maxVisible = 5;

    # Options not exposed as direct HM attrs
    extraConfig = ''
      width=380
      height=120
      border-radius=8
      border-size=2
      margin=10
      padding=12,16

      [urgency=critical]
      default-timeout=0
    '';
  };
}
