local M = {
  loaded = {},
  available = {
    vim_options = "03-native.vim-options",
    vim_lsp_diagnostics = "03-native.vim-lsp-diagnostics",
    vim_highlights = "03-native.vim-highlights"
  }
}

local autoload = {
  M.available.vim_lsp_diagnostics,
  M.available.vim_options,
  M.available.vim_highlights,
}

for _, module_path in ipairs(autoload) do
  local module_ok, module = pcall(require, module_path)

  if module_ok then
    table.insert(M.loaded, module_path)
  else
    PrintDbg('Stage 03-native failed to autoload module: ' .. module_path, LL_ERROR, { module_ok, module })
  end
end

return M
