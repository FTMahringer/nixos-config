-- nvim-tree-delete.lua - File/folder deletion with confirmation for NvimTree
local M = {}

local function get_node_path(api)
  local node = api.tree.get_node_under_cursor()
  if not node or not node.absolute_path then return nil end
  return node.absolute_path
end

M.delete = function()
  local ok, api = pcall(require, "nvim-tree.api")
  if not ok then
    vim.notify("nvim-tree is not available", vim.log.levels.ERROR)
    return
  end

  local path = get_node_path(api)
  if not path then
    vim.notify("Could not determine target path", vim.log.levels.WARN)
    return
  end

  local name = vim.fn.fnamemodify(path, ":t")

  vim.ui.select(
    { "Yes", "No" },
    { prompt = "Are you sure you want to delete '" .. name .. "'?" },
    function(choice)
      if choice ~= "Yes" then return end

      local stat = vim.loop.fs_stat(path)
      if stat and stat.type == "directory" then
        vim.fn.delete(path, "rf")
      else
        vim.fn.delete(path)
      end

      api.tree.reload()
      vim.notify("Deleted: " .. vim.fn.fnamemodify(path, ":~"), vim.log.levels.INFO)
    end
  )
end

package.loaded["nvim-tree-delete"] = M
