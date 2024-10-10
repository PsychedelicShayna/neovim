--    |                                     |  Mode Characters Quick Reference
--    | N | Normal           | I | Insert   |
--    | V | Visual           | X | Vblock   |
--    | C | Command          | T | Terminal |
--    |_____________________________________|

--  ! Leader Key !
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

---@param binding table
---@return boolean
--- More convenient way to set keybinds.
function MapKey(binding)
  if type(binding) ~= 'table' then
    PrintDbg("MapKey: binding is not a table, was ", LL_ERROR, { binding })
    return false
  end

  if binding.modes == nil then
    binding.modes = 'n'
  elseif Safe.t_not(binding.modes, { 'string', 'table' }) then
    PrintDbg("Invalid type for mode to bind key to!", LL_ERROR, { binding })
    return false
  end

  if type(binding.opts) ~= 'table' then
    binding.opts = {
      noremap = true,
      silent = true
    }
  end

  if binding.unset == true then
    vim.unset_keymap(binding.modes, binding.key)
  end

  binding.opts.desc = (type(binding.desc) == 'string' and binding.desc) or nil

  vim.keymap.set(
    binding.modes,
    binding.key,
    binding.does,
    binding.opts
  )

  return true
end
