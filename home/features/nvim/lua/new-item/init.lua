local M = {}

--- Return the directory path the cursor is currently in.
--- If the cursor is on a file, returns its parent dir.
--- If the cursor is on a directory, returns that directory itself.
local function get_parent_path(api)
  local node = api.tree.get_node_under_cursor()
  if not node or not node.absolute_path then return nil end

  if node.fs_stat and node.fs_stat.type == "directory" then
    return node.absolute_path
  else
    return vim.fn.fnamemodify(node.absolute_path, ":h")
  end
end

--- Show a "File / Folder" picker, then hand off to the relevant module.
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
        require("new-item.file").create(parent_path, api)
      else
        require("new-item.folder").create(parent_path, api)
      end
    end
  )
end

return M
