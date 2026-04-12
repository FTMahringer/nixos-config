{ pkgs, ... }:

{
  programs.nvf = {
    enable = true;
    defaultEditor = true;
    enableManpages = true;

    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        options = {
          number = true;
          relativenumber = true;
          mouse = "a";
          wrap = false;
          scrolloff = 4;
          sidescrolloff = 4;

          tabstop = 2;
          shiftwidth = 2;
          softtabstop = 2;
          expandtab = true;
          autoindent = true;
          smartindent = false;
          breakindent = true;

          ignorecase = true;
          smartcase = true;
          hlsearch = true;
          incsearch = true;

          showmode = false;
          signcolumn = "yes";
          cursorline = true;
        };

        telescope.enable = true;

        statusline.lualine.enable = true;

        filetree.nvimTree = {
          enable = true;
          setupOpts = {
            hijack_netrw = true;
            hijack_cursor = true;
            sync_root_with_cwd = true;
            update_focused_file = {
              enable = true;
              update_root = false;
            };
            view = {
              width = 15;
              side = "left";
              preserve_window_proportions = true;
            };
            renderer = {
              group_empty = true;
              highlight_git = true;
              icons = {
                show = {
                  git = true;
                  file = true;
                  folder = true;
                  folder_arrow = true;
                };
              };
            };
            filters.dotfiles = false;
            git.enable = true;
          };
        };

        git = {
          enable = true;
          gitsigns.enable = true;
        };

        autocomplete.nvim-cmp.enable = true;

        lsp.enable = true;
        languages = {
          enableTreesitter = true;
          enableFormat = true;

          nix = {
            enable = true;
            format.enable = true;
          };

          markdown = {
            enable = true;
            format.enable = true;
          };

          bash = {
            enable = true;
            format.enable = true;
          };
        };

        keymaps = [
          {
            key = "<leader>e";
            mode = [ "n" ];
            action = "<cmd>NvimTreeToggle<CR>";
            silent = true;
          }
          {
            key = "<leader>E";
            mode = [ "n" ];
            action = "<cmd>NvimTreeFindFile<CR>";
            silent = true;
          }
          {
            key = "<C-s>";
            mode = [ "n" ];
            action = "<cmd>w<CR>";
            silent = true;
          }
          {
            key = "<C-s>";
            mode = [ "i" ];
            action = "<Esc><cmd>w<CR>a";
            silent = true;
          }
          {
            key = "<C-k>";
            mode = [ "n" ];
            action = "dd";
            silent = true;
          }
          {
            key = "<C-k>";
            mode = [ "i" ];
            action = "<Esc>ddi";
            silent = true;
          }
          {
            key = "<leader>h";
            mode = [ "n" ];
            action = "<cmd>nohlsearch<CR>";
            silent = true;
          }
        ];

        # Note: luaConfigRC is now a DAG type in newer NVF versions
        # Use luaConfigPre or luaConfigPost for plain string config
        luaConfigPre = ''
          vim.opt.clipboard = "unnamedplus"
          vim.opt.backspace = { "indent", "eol", "start" }

          if vim.env.TERM ~= "linux" then
            vim.opt.termguicolors = true
          end
        '';

        luaConfigPost = ''
          vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
            pattern = "*.nix",
            callback = function()
              vim.bo.filetype = "nix"
              vim.bo.tabstop = 2
              vim.bo.shiftwidth = 2
              vim.bo.softtabstop = 2
              vim.bo.expandtab = true
              vim.bo.autoindent = true
              vim.bo.smartindent = false
            end,
          })

          local autopairs_map = {
            ["("] = ")",
            ["["] = "]",
            ["{"] = "}",
            ['"'] = '"',
            ["'"] = "'",
          }

          for open_char, close_char in pairs(autopairs_map) do
            vim.keymap.set("i", open_char, open_char .. close_char .. "<Left>", {
              noremap = true,
              silent = true,
            })
          end

          vim.keymap.set("i", "<CR>", function()
            local indent = vim.fn.matchstr(vim.fn.getline("."), "^%s*")
            return "<CR>" .. indent
          end, { expr = true, noremap = true })
        '';
      };
    };
  };
}
