-- new-item.lua - File/folder creation for NvimTree
local M = {}

-- File creation
local function create_file(parent_path, api)
  vim.ui.input({ prompt = "  File name: " }, function(name)
    if not name or name == "" then return end
    local full_path = parent_path .. "/" .. name
    local dir = vim.fn.fnamemodify(full_path, ":h")
    vim.fn.mkdir(dir, "p")
    vim.fn.writefile({}, full_path)
    api.tree.reload()
    -- Open in a vertical split on the right side (not full screen)
    vim.cmd("vsplit " .. vim.fn.fnameescape(full_path))
  end)
end

-- Folder creation
local function create_folder(parent_path, api)
  vim.ui.input({ prompt = "  Folder name: " }, function(name)
    if not name or name == "" then return end
    local full_path = parent_path .. "/" .. name
    vim.fn.mkdir(full_path, "p")
    api.tree.reload()
  end)
end

-- Get parent directory of current node
local function get_parent_path(api)
  local node = api.tree.get_node_under_cursor()
  if not node or not node.absolute_path then return nil end
  if node.fs_stat and node.fs_stat.type == "directory" then
    return node.absolute_path
  else
    return vim.fn.fnamemodify(node.absolute_path, ":h")
  end
end

-- Main entry point
M.create = function()
  local ok, api = pcall(require, "nvim-tree.api")
  if not ok then
    vim.notify("nvim-tree is not available", vim.log.levels.ERROR)
    return
  end

  local parent_path = get_parent_path(api)
  if not parent_path then
    vim.notify("Could not determine target directory", vim.log.levels.WARN)
    return
  end

  local display = vim.fn.fnamemodify(parent_path, ":~")

  vim.ui.select(
    { "  File", "  Folder" },
    { prompt = "New item in " .. display .. ":" },
    function(choice)
      if not choice then return end
      if choice:match("File") then
        create_file(parent_path, api)
      else
        create_folder(parent_path, api)
      end
    end
  )
end

package.loaded["new-item"] = M
