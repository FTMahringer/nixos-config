local M = {}

--- Prompt for a filename and create it under `parent_path`.
--- The new file is opened in the editor after creation.
M.create = function(parent_path, api)
  vim.ui.input({ prompt = "  File name: " }, function(name)
    if not name or name == "" then return end

    local full_path = parent_path .. "/" .. name

    -- Create any intermediate directories (e.g. "src/foo/bar.lua")
    local dir = vim.fn.fnamemodify(full_path, ":h")
    vim.fn.mkdir(dir, "p")
    vim.fn.writefile({}, full_path)

    api.tree.reload()
    vim.cmd("edit " .. vim.fn.fnameescape(full_path))
  end)
end

return M
