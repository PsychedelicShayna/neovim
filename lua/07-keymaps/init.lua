local M = {
  loaded = {},
  available = {
    editor_navigation = '07-keymaps.editor_navigation',
    lsp_control       = '07-keymaps.lsp_control',
  }
}

M.autoload = {
  M.available.editor_navigation,
  M.available.lsp_control
}

for index, path in ipairs(M.autoload) do
  local module_ok, module = pcall(require, path)

  if module_ok then
    table.insert(M.loaded, path)
  else
    PrintDbg(
      'Stage #7, failed to autoload keymap module # ' .. index .. ': ' .. vim.inspect(path),
      LL_ERROR,
      { module_ok, module }
    )
  end
end
