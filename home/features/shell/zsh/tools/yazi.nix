{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true; # adds shell wrapper that cds on exit
    shellWrapperName = "y";      # explicit: silence deprecation warning

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
