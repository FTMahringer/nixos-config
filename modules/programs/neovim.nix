{ config, pkgs, lib, ... }: 

let 
  cfg = config.ft.programs.neovim;
in
{
  options.ft.programs.neovim = {
    enable = lib.mkEnableOption "NeoVim";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    environment.systemPackages = with pkgs; [
      neovim
    ];
  };
}
