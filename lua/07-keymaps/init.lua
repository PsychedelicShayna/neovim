--    |                                     |  Mode Characters Quick Reference
--    | N | Normal           | I | Insert   |
--    | V | Visual           | X | Vblock   |
--    | C | Command          | T | Terminal |
--    |_____________________________________|

--  ! Leader Key !
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


function MapKey(binding)
  if Safe.t_not(binding, 'table') then
    PrintDbg("MapKey: binding is not a table, was ", LL_ERROR, { binding })
    return false
  end

  if Safe.t_not(binding, { 'string', 'table' }) then
    PrintDbg("Cannot map key because it wasn't ", LL_ERROR, { binding })
    return false
  end

  if Safe.t_is(binding.modes, 'nil') then
    binding.modes = 'n'
  elseif Safe.t_not(binding.modes, { 'string', 'table' }) then
    PrintDbg("Invalid type for mode to bind key to!", LL_ERROR, { binding })
    return false
  end

  if Safe.t_not(binding.opts, 'table') then
    binding.opts = {
      noremap = true,
      silent = true
    }
  end

  if Safe.t_is(binding.opts, 'overwrite') then
    vim.unset_keymap(binding.modes, binding.key)
  end

  vim.keymap.set(
    binding.modes,
    binding.key,
    binding.does,
    binding.opts
  )

  if Safe.t_not(binding.description, { 'nil', 'string' }) then
    PrintDbg(
      "Description of keybind has an invalid type.", LL_WARN, {
        binding.description
      }
    )

    binding.description = nil
  end

  Events.fire_event {
    actor = 'MapKey',
    event = 'mapped',
    data  = binding.description or nil
  }
end

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
