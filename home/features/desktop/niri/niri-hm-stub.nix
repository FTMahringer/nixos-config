{ lib, ... }:

# Minimal stub that declares the programs.niri option namespace.
#
# The ft-nixlaunch niri integration (from ft-nixpkgs) references
# programs.niri.settings.binds even when compositor != "Niri", which
# causes an evaluation error if the option doesn't exist.  This stub
# provides just enough of the type shape to satisfy the module system.
#
# This can be removed once ft-nixpkgs ships a ft-nixlaunch version that
# guards the reference with `options ? programs.niri`.
{
  options.programs.niri = {
    enable = lib.mkEnableOption "niri scrolling Wayland compositor (HM)";

    settings = lib.mkOption {
      type    = lib.types.attrsOf lib.types.anything;
      default = {};
      description = "Niri settings passed to programs.niri (stub).";
    };
  };
}
