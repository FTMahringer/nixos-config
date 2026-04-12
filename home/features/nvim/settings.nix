{ pkgs, lib, ... }:

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

        tabline.nvimBufferline.enable = false;

        filetree.nvimTree = {
          enable = true;
          openOnSetup = true;
          setupOpts = {
            hijack_netrw = true;
            hijack_cursor = true;
            sync_root_with_cwd = true;
            update_focused_file = {
              enable = true;
              update_root = false;
            };
            view = {
              width = 30;
              side = "left";
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
            key = "<C-x>";
            mode = [ "n" ];
            action = "<cmd>q<CR>";
            silent = true;
          }
          {
            key = "<leader>h";
            mode = [ "n" ];
            action = "<cmd>nohlsearch<CR>";
            silent = true;
          }
        ];

        luaConfigPre = ''
          vim.opt.clipboard = "unnamedplus"
          vim.opt.backspace = { "indent", "eol", "start" }

          if vim.env.TERM ~= "linux" then
            vim.opt.termguicolors = true
          end

          -- Load new-item module
          ${builtins.readFile ./lua/new-item.lua}

          -- Load nvim-tree-delete module
          ${builtins.readFile ./lua/nvim-tree-delete.lua}

          -- Load nvim-tree-terminal module
          ${builtins.readFile ./lua/nvim-tree-terminal.lua}
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

          -- Ctrl+N inside NvimTree → file/folder creation popup
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "NvimTree",
            callback = function(args)
              vim.keymap.set("n", "<C-n>", function()
                require("new-item").create()
              end, { buffer = args.buf, noremap = true, silent = true, desc = "New file/folder" })

              vim.keymap.set("n", "<C-d>", function()
                require("nvim-tree-delete").delete()
              end, { buffer = args.buf, noremap = true, silent = true, desc = "Delete file/folder" })

              -- Ctrl+T to toggle/open terminal at bottom
              vim.keymap.set("n", "<C-t>", function()
                require("nvim-tree-terminal").toggle()
              end, { buffer = args.buf, noremap = true, silent = true, desc = "Toggle terminal" })

              -- Ctrl+Shift+T to close terminal
              vim.keymap.set("n", "<C-S-t>", function()
                require("nvim-tree-terminal").close()
              end, { buffer = args.buf, noremap = true, silent = true, desc = "Close terminal" })
            end,
          })

          -- Force the NvimTree window to 30 cols whenever it appears
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "NvimTree",
            callback = function()
              vim.api.nvim_win_set_width(0, 30)
            end,
          })

          -- When opening a file from NvimTree, resize it to 30 cols
          -- This ensures the split is 25:75 (30 cols vs remaining)
          vim.api.nvim_create_autocmd("BufWinEnter", {
            callback = function()
              local tree_wins = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype == "NvimTree" then
                  table.insert(tree_wins, win)
                end
              end
              for _, win in ipairs(tree_wins) do
                vim.api.nvim_win_set_width(win, 30)
              end
            end,
          })

          -- Terminal buffer keymaps
          vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "*",
            callback = function(args)
              -- Ctrl+T in terminal to go back to file tree
              vim.keymap.set("t", "<C-t>", function()
                require("nvim-tree-terminal").focus_tree()
              end, { buffer = args.buf, noremap = true, silent = true, desc = "Focus file tree" })

              -- Ctrl+Shift+T in terminal to close terminal
              vim.keymap.set("t", "<C-S-t>", function()
                require("nvim-tree-terminal").close()
              end, { buffer = args.buf, noremap = true, silent = true, desc = "Close terminal" })

              -- Escape to exit terminal insert mode
              vim.keymap.set("t", "<Esc>", "<C-\><C-n>", { buffer = args.buf, noremap = true, silent = true })
            end,
          })
        '';
      };
    };
  };
}
