local M = {}

local exported_modules = {
 "diagnostic_signs",
 "editor",
 "init",
 "neovide",
 "shell",
}

local prefix = "user.preferences.modules."

for _, module_name in ipairs(exported_modules) do
  local module_path = prefix .. module_name
  local module_ok, module = pcall(require, module_path)

  if not module_ok then
    vim.notify('Failed to import "' .. module_path .. '"')
    PrintDbg(module, module_name)
  else
    M.module_name = module
  end
end

return M
