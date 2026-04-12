-- nvim-tree-terminal.lua - Terminal toggle at bottom for NvimTree
local M = {}

local term_buf = nil
local term_win = nil
local term_height = 15

-- Get the root directory of the nvim-tree
local function get_tree_root()
  local ok, api = pcall(require, "nvim-tree.api")
  if not ok then return vim.loop.cwd() end

  local core = require("nvim-tree.core")
  local root = core.get_explorer_root()
  if root then
    return root.absolute_path
  end
  return vim.loop.cwd()
end

-- Open terminal at bottom
M.open = function()
  -- If terminal window already exists and is valid, just focus it
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_set_current_win(term_win)
    return
  end

  -- Get current window layout
  local current_win = vim.api.nvim_get_current_win()

  -- Create a new horizontal split at bottom
  vim.cmd("botright split")
  vim.cmd("resize " .. term_height)

  term_win = vim.api.nvim_get_current_win()

  -- If we have an existing terminal buffer, use it
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_win_set_buf(term_win, term_buf)
  else
    -- Open terminal in current window
    local root_dir = get_tree_root()
    vim.cmd("terminal")
    term_buf = vim.api.nvim_get_current_buf()

    -- Set buffer name
    vim.api.nvim_buf_set_name(term_buf, "NvimTreeTerminal")

    -- Change to the root directory
    local chan = vim.bo[term_buf].channel
    if chan then
      vim.fn.chansend(chan, "cd " .. vim.fn.fnameescape(root_dir) .. "\n")
    end

    -- Set terminal buffer options
    vim.bo[term_buf].buflisted = false
    vim.bo[term_buf].bufhidden = "hide"
  end

  -- Start in insert mode for terminal
  vim.cmd("startinsert")
end

-- Focus the file tree (go back from terminal)
M.focus_tree = function()
  -- Find the nvim-tree window
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "NvimTree" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  vim.notify("NvimTree not found", vim.log.levels.WARN)
end

-- Close terminal
M.close = function()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
  end
end

-- Toggle terminal visibility
M.toggle = function()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    -- Terminal is open, check if we're in it
    local current_win = vim.api.nvim_get_current_win()
    if current_win == term_win then
      -- We're in terminal, go back to tree
      M.focus_tree()
    else
      -- Terminal is open but we're not in it, focus it
      vim.api.nvim_set_current_win(term_win)
      vim.cmd("startinsert")
    end
  else
    -- Terminal not open, open it
    M.open()
  end
end

package.loaded["nvim-tree-terminal"] = M
