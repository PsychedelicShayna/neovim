--    |                                     |  Mode Characters Quick Reference
--    | N | Normal           | I | Insert   |
--    | V | Visual           | X | Vblock   |
--    | C | Command          | T | Terminal |
--    |_____________________________________|

--  ! Leader Key !
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

function MapKey(binding)
  if (type(binding) ~= 'table'
        or not binding.key
        or not binding.does
        or type(binding.key) ~= 'string'
        or type(binding.does) ~= 'string'
      ) then
    return false
  end

  if not binding.in_mode or type(binding.in_mode) ~= 'string' then
    binding.in_mode = 'n'
  end

  if not binding.with_options or type(binding.with_options) ~= 'table' then
    binding.with_options = {
      noremap = true,
      silent = true
    }
  end

  vim.keymap.set(
    binding.in_mode,
    binding.key,
    binding.does,
    binding.with_options
  )

  -- which_key.register(mappings, {
  --   prefix = "<leader>l",
  --   mode = "n",
  --   buffer = bufnr
  -- })
  --
  local event_table = { actor = "MapKey", event = "new" }

  if binding.with_wk == 'table' then
    event_table['data'] = binding.with_wk
  end

  Events.fire_event(event_table)
end

local M = {
  loaded = {},
  available = {
    editor_navigation  = '07-keymaps.editor_navigation',
    lsp_control        = '07-keymaps.lsp_control',
    backend_control    = '07-keymaps.backend_control',
    plugin_integration = '07-keymaps.plugin_integration',
    enhancements       = '07-keymaps.enhancements',
    lsp_control        = '07-keymaps.lsp_control'
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
