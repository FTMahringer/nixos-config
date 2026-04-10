{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true; # adds `y` shell wrapper that cds on exit

    settings = {
      manager = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
        show_symlink = true;
      };

      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
      };
    };

    theme = {
      flavor = {
        use = "gruvbox-dark";
      };
    };

    flavors = {
      gruvbox-dark = pkgs.fetchFromGitHub {
        owner = "bennyyip";
        repo = "gruvbox-dark.yazi";
        rev = "main";
        sha256 = "sha256-mH6QTQQPJNR3GVpa09UpFMcaOTJN4IqdRuDsTLKGxk=";
      };
    };

    keymap = {
      manager.prepend_keymap = [
        # Quick open with fzf
        { on = [ "F" ]; run = ''shell 'yazi "$(fzf)"' --confirm''; desc = "Open file with fzf"; }
        # Toggle hidden files
        { on = [ "." ]; run = "hidden toggle"; desc = "Toggle hidden files"; }
        # Open terminal in current dir
        { on = [ "<C-t>" ]; run = ''shell '$SHELL' --block --confirm''; desc = "Open shell here"; }
        # Extract archive
        { on = [ "X" ]; run = ''shell 'aunpack "$1"' --confirm''; desc = "Extract archive"; }
      ];
    };
  };
}
