{ inputs, ... }:
{
  imports = [
    ./features
    # NOTE: ft-nixpalette is NOT imported here.
    # We use the NixOS module (system-wide Stylix + DE integration).
    # The HM module (homeModules.default) is for standalone HM usage only.
    # Do NOT mix both â€” they each configure Stylix and will conflict.
  ];

  home = {
    username = "fynn";
    homeDirectory = "/home/fynn";
    stateVersion = "25.11";
  };
}
