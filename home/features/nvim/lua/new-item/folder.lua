local M = {}

--- Prompt for a folder name and create it under `parent_path`.
M.create = function(parent_path, api)
  vim.ui.input({ prompt = "  Folder name: " }, function(name)
    if not name or name == "" then return end

    local full_path = parent_path .. "/" .. name
    vim.fn.mkdir(full_path, "p")

    api.tree.reload()
  end)
end

return M
